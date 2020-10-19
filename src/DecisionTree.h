/* Copyright (C) 2019 Alexis Remmers and Nodari Kankava
 * Copyright (C) 2020 Sankalp Gambhir
 *
 * This file is part of Nidhugg.
 *
 * Nidhugg is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Nidhugg is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see
 * <http://www.gnu.org/licenses/>.
 */

#include <config.h>
#ifndef __DECISION_TREE_H__
#define __DECISION_TREE_H__

#include "SymEv.h"
//#include "SaturatedGraph.h"
#include "UnfoldingTree.h"

#include <unordered_set>
#include <mutex>
#include <queue>
#include <atomic>


template <class Graph> struct DecisionNode;

struct Branch {
public:
  Branch(int pid, int size, int decision_depth, bool pinned, SymEv sym)
    : pid(pid), size(size), decision_depth(decision_depth), pinned(pinned),
      sym(std::move(sym)) {}
  Branch() : Branch(-1, 0, -1, false, {}) {}
  int pid, size, decision_depth;
  bool pinned;
  SymEv sym;
};


struct Leaf {
public:
  /* Construct a bottom-leaf. */
  Leaf() : prefix() {}
  /* Construct a prefix leaf. */
  Leaf(std::vector<Branch> prefix) : prefix(prefix) {}
  std::vector<Branch> prefix;

  bool is_bottom() const { return prefix.empty(); }
};

template <class Graph>
struct DecisionNode {
public:
  /* Empty constructor for root. */
  DecisionNode() : depth(-1), parent(nullptr), pruned_subtree(false),
                   cache_initialised(true) {}
  /* Constructor for new nodes during compute_unfolding. */
  DecisionNode(std::shared_ptr<DecisionNode> decision)
    : depth(decision->depth+1), pruned_subtree(false),
      cache_initialised(false) {
    parent = std::move(decision);
  }
  /* Constructor for new siblings during compute_prefixes. */
  DecisionNode(std::shared_ptr<DecisionNode> decision,
               std::shared_ptr<UnfoldingTree::UnfoldingNode> unf, Leaf l)
    : depth(decision->depth+1), unfold_node(std::move(unf)), leaf(l),
      pruned_subtree(false), cache_initialised(false) {
    parent = std::move(decision);
  }

  /* The depth in the tree. */
  int depth;

  /* The UnfoldingNode of a new sibling. */
  std::shared_ptr<UnfoldingTree::UnfoldingNode> unfold_node;

  /* The Leaf of a new sibling. */
  Leaf leaf;

  /* Tries to allocate a given UnfoldingNode.
   * Returns false if it previously been allocated by this node or any previous
   * sibling. */
  bool try_alloc_unf(const std::shared_ptr<UnfoldingTree::UnfoldingNode> &unf);
  /* Allocates the given UnfoldingNode, assuming it has not been allocated before */
  void alloc_unf(std::shared_ptr<UnfoldingTree::UnfoldingNode> unf);

  /* Constructs a sibling and inserts in in the sibling-set. */
  std::shared_ptr<DecisionNode> make_sibling
  (std::shared_ptr<UnfoldingTree::UnfoldingNode> unf, Leaf l) const;

  /* Returns a given nodes Graph, or reuses an ancestors graph if none exist. */
  const Graph &get_saturated_graph(std::function<void(Graph&)>);

  static const std::shared_ptr<DecisionNode> &get_ancestor
  (const DecisionNode * node, int wanted);

  /* Using the last decision that caused a failure, and then
   * prune all later decisions. */
  void prune_decisions();

  /* True if node is part of a pruned subtree. */
  bool is_pruned();

private:

  std::shared_ptr<DecisionNode> parent;

  /* Defines if the subtree should be evaluated or not.
   * Set to true if prune_decision noted that all leafs with this node as
   * ancestor should not be explored. */
  std::atomic_bool pruned_subtree;

  /* Wether the graph cache has been initialised */
  std::atomic_bool cache_initialised;

  // The following fields are held by a parent to be accessed by every child.

  /* Set of all known UnfoldingNodes from every child nodes' evaluation. */
  std::unordered_set<std::shared_ptr<UnfoldingTree::UnfoldingNode>>
  children_unf_set;

  /* Cached Graph containing all events up to this one */
  Graph graph_cache;

  /* mutex to ensure exclusive access to a nodes' unfolding-set and saturated graph. */
  std::mutex decision_node_mutex;
};


/* Comparator to define DecisionTree priority queue ordering.
 * This is operated in a depth-first ordering, meaning it will prioritise to
 * exhaust the exploration of the lowest subtrees first so that they could be
 * garbage-collected faster. */
template <class Graph>
class DecisionCompare {
public:
  bool operator()(const std::shared_ptr<DecisionNode<Graph> > &a,
                  const std::shared_ptr<DecisionNode<Graph> > &b) const {
    return a->depth < b->depth;
  }
};

template <class Graph>
struct Scheduler {
  virtual ~Scheduler();
  virtual void enqueue(std::shared_ptr<DecisionNode<Graph> > node) = 0;
  virtual std::shared_ptr<DecisionNode<Graph> > dequeue() = 0;
  virtual void halt() = 0;
  virtual void register_thread(unsigned tid){}
  std::atomic<uint64_t> outstanding_jobs{0};
};

template <class Graph>
class PriorityQueueScheduler final : public Scheduler {
public:
  PriorityQueueScheduler();
  ~PriorityQueueScheduler() override = default;
  void enqueue(std::shared_ptr<DecisionNode<Graph> > node) override;
  std::shared_ptr<DecisionNode<Graph> > dequeue() override;
  void halt() override;
private:
  /* Exclusive access to the work_queue. */
  std::mutex mutex;
  std::condition_variable cv;

  /* Set to indicate that no more jobs should be dispatched */
  bool halting = false;

  /* Work queue of leaf nodes to explore.
   * The ordering is determined by DecisionCompare. */
  std::priority_queue<std::shared_ptr<DecisionNode>, std::vector<std::shared_ptr<DecisionNode>>, DecisionCompare> work_queue;
};

template <class Graph>
class WorkstealingPQScheduler final : public Scheduler {
public:
  WorkstealingPQScheduler(unsigned num_threads);
  ~WorkstealingPQScheduler() override = default;
  void enqueue(std::shared_ptr<DecisionNode<Graph> > node) override;
  std::shared_ptr<DecisionNode<Graph> > dequeue() override;
  void halt() override;
  void register_thread(unsigned id) override {
    assert(id >= 0 && id < work_queue.size());
    thread_id = id;
  }

private:
  class alignas(64) ThreadWorkQueue {
    std::map<int,std::deque<std::shared_ptr<DecisionNode>>> queue;
  public:
    void push(std::shared_ptr<DecisionNode<Graph> > ptr) {
      assert(ptr);
      queue[ptr->depth].emplace_back(std::move(ptr));
    }
    std::shared_ptr<DecisionNode<Graph> > pop();
    bool empty() const { return queue.empty(); }
    bool steal(ThreadWorkQueue &other);
    std::mutex mutex;
  };

  std::mutex mutex;
  std::condition_variable cv;
  std::vector<ThreadWorkQueue> work_queue;
  static thread_local int thread_id;
  std::atomic<bool> halting;
};

template <class Graph>
class DecisionTree final {
public:
  RFSCDecisionTree(std::unique_ptr<Scheduler> scheduler)
    : scheduler(std::move(scheduler)) {
    // Initiallize the work_queue with a "root"-node
    this->scheduler->enqueue(std::make_shared<DecisionNode<Graph> >());
  };


  /* Backtracks a TraceBuilders DecisionNode up to an ancestor with not yet
   * evaluated sibling. */
  void backtrack_decision_tree(std::shared_ptr<DecisionNode<Graph> > *TB_work_item);

  /* Get a new prefix to execute from the scheduler */
  std::shared_ptr<DecisionNode<Graph> > get_next_work_task() { return scheduler->dequeue(); }

  /* Constructs an empty Decision node. */
  std::shared_ptr<DecisionNode<Graph> > new_decision_node
  (std::shared_ptr<DecisionNode<Graph> > parent,
   std::shared_ptr<UnfoldingTree::UnfoldingNode> unf);

  /* Constructs a sibling Decision node and add it to work queue. */
  void construct_sibling
  (const DecisionNode<Graph> &decision,
   std::shared_ptr<UnfoldingTree::UnfoldingNode> unf, Leaf l);

  /* Given a DecisionNode whose depth >= to wanted, returns a parent with the wanted depth. */
  static const std::shared_ptr<DecisionNode<Graph> > &find_ancestor
  (const std::shared_ptr<DecisionNode<Graph> > &node, int wanted);

  Scheduler<Graph> &get_scheduler() { return *scheduler; }

private:
  std::unique_ptr<Scheduler<Graph> > scheduler;
};


#endif
