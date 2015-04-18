// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

template <typename T>
int share_vector(const std::vector<T>& vec, const char* seg_name, const char* obj_name) {
  using namespace boost::interprocess;

  shared_memory_object::remove(seg_name);

  managed_shared_memory segment(create_only,
    seg_name, vec.size() * sizeof(T) + 1024);

  const T *x_begin = &vec.front();
  const T *y_end = x_begin + vec.size();

  typedef typename SHARED_VECTOR_TYPE<T>::ShmemAllocator ShmemAllocator;
  typedef typename SHARED_VECTOR_TYPE<T>::SharedVector SharedVector;

  const ShmemAllocator alloc_inst (segment.get_segment_manager());

  SharedVector *sv =
    segment.construct<SharedVector>
    (obj_name)/*object name*/
    (x_begin     /*first ctor parameter*/,
      y_end     /*second ctor parameter*/,
      alloc_inst /*third ctor parameter*/);

  return 0;
}

// [[Rcpp::export]]
int share_integer_vector(const std::vector<int>& vec, const char* seg_name, const char* obj_name) {
  return share_vector<int>(vec, seg_name, obj_name);
}

// [[Rcpp::export]]
int share_numeric_vector(const std::vector<double>& vec, const char* seg_name, const char* obj_name) {
  return share_vector<double>(vec, seg_name, obj_name);
}
