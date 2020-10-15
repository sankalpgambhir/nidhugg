#include <cassert>
#include <atomic>
#include <thread>

std::atomic<int> x(0), y(0), v[1];


void t0(){
    x.store(1, std::memory_order_relaxed);
}

void t1(){
    x.store(2, std::memory_order_relaxed);
}

void  t2(){
    int v0 = x.load(std::memory_order_relaxed);
    int v1 = x.load(std::memory_order_relaxed);
    int v2 = x.load(std::memory_order_relaxed);
    int v3 = x.load(std::memory_order_relaxed);

    int v4 = (v0 == 1) & (v1 == 2);
    int v5 = (v2 == 1) & (v3 == 2);
    int v6 = v4 & v5;

    v[0].store(v6, std::memory_order_seq_cst); // ensure this happens at the end
    // is this correct?
}

int main(){

    pthread_t threads[3];

    pthread_create(&threads[0], nullptr, [](void*) -> void* {t0(); return nullptr;}, nullptr);
    pthread_create(&threads[1], nullptr, [](void*) -> void* {t1(); return nullptr;}, nullptr);
    pthread_create(&threads[2], nullptr, [](void*) -> void* {t2(); return nullptr;}, nullptr);

    for(auto t : threads){
        pthread_join(t, nullptr);
    }

    int vf = v[0].load(std::memory_order_seq_cst);
    if (vf != 0) assert(0 && "Behavior found");

    return 0;
}

