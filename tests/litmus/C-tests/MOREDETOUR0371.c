/* Copyright (C) 2018 Magnus Lång and Tuan Phong Ngo
 * This benchmark is part of SWSC */

#include <assert.h>
#include <stdint.h>
#include <stdatomic.h>
#include <pthread.h>

atomic_int vars[2]; 
atomic_int atom_0_r3_0; 
atomic_int atom_1_r3_2; 
atomic_int atom_2_r1_2; 
atomic_int atom_3_r1_4; 

void *t0(void *arg){
label_1:;
  atomic_store_explicit(&vars[0], 2, memory_order_seq_cst);
  int v2_r3 = atomic_load_explicit(&vars[1], memory_order_seq_cst);
  atomic_store_explicit(&vars[1], 2, memory_order_seq_cst);
  atomic_store_explicit(&vars[1], 4, memory_order_seq_cst);
  int v24 = (v2_r3 == 0);
  atomic_store_explicit(&atom_0_r3_0, v24, memory_order_seq_cst);
  return NULL;
}

void *t1(void *arg){
label_2:;
  atomic_store_explicit(&vars[1], 1, memory_order_seq_cst);

  int v4_r3 = atomic_load_explicit(&vars[1], memory_order_seq_cst);
  int v25 = (v4_r3 == 2);
  atomic_store_explicit(&atom_1_r3_2, v25, memory_order_seq_cst);
  return NULL;
}

void *t2(void *arg){
label_3:;
  int v6_r1 = atomic_load_explicit(&vars[1], memory_order_seq_cst);
  atomic_store_explicit(&vars[1], 3, memory_order_seq_cst);
  int v26 = (v6_r1 == 2);
  atomic_store_explicit(&atom_2_r1_2, v26, memory_order_seq_cst);
  return NULL;
}

void *t3(void *arg){
label_4:;
  int v8_r1 = atomic_load_explicit(&vars[1], memory_order_seq_cst);
  int v9_r3 = v8_r1 ^ v8_r1;
  int v10_r3 = v9_r3 + 1;
  atomic_store_explicit(&vars[0], v10_r3, memory_order_seq_cst);
  int v27 = (v8_r1 == 4);
  atomic_store_explicit(&atom_3_r1_4, v27, memory_order_seq_cst);
  return NULL;
}

int main(int argc, char *argv[]){
  pthread_t thr0; 
  pthread_t thr1; 
  pthread_t thr2; 
  pthread_t thr3; 

  atomic_init(&vars[1], 0);
  atomic_init(&vars[0], 0);
  atomic_init(&atom_0_r3_0, 0);
  atomic_init(&atom_1_r3_2, 0);
  atomic_init(&atom_2_r1_2, 0);
  atomic_init(&atom_3_r1_4, 0);

  pthread_create(&thr0, NULL, t0, NULL);
  pthread_create(&thr1, NULL, t1, NULL);
  pthread_create(&thr2, NULL, t2, NULL);
  pthread_create(&thr3, NULL, t3, NULL);

  pthread_join(thr0, NULL);
  pthread_join(thr1, NULL);
  pthread_join(thr2, NULL);
  pthread_join(thr3, NULL);

  int v11 = atomic_load_explicit(&atom_0_r3_0, memory_order_seq_cst);
  int v12 = atomic_load_explicit(&atom_1_r3_2, memory_order_seq_cst);
  int v13 = atomic_load_explicit(&vars[1], memory_order_seq_cst);
  int v14 = (v13 == 4);
  int v15 = atomic_load_explicit(&atom_2_r1_2, memory_order_seq_cst);
  int v16 = atomic_load_explicit(&vars[0], memory_order_seq_cst);
  int v17 = (v16 == 2);
  int v18 = atomic_load_explicit(&atom_3_r1_4, memory_order_seq_cst);
  int v19_conj = v17 & v18;
  int v20_conj = v15 & v19_conj;
  int v21_conj = v14 & v20_conj;
  int v22_conj = v12 & v21_conj;
  int v23_conj = v11 & v22_conj;
  if (v23_conj == 1) assert(0);
  return 0;
}
