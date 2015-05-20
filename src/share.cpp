// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

size_t EXTRA_BUFFER_SIZE = 1024;

template <typename T>
int share_vector(const std::vector<T>& vec, const char* seg_name, const char* obj_name,
  const bool& overwrite) {
  using namespace boost::interprocess;

  if (overwrite) {
    shared_memory_object::remove(seg_name);
  }

  managed_shared_memory segment(create_only,
    seg_name, vec.size() * sizeof(T) + EXTRA_BUFFER_SIZE);

  const T *x_begin = &vec.front();
  const T *y_end = x_begin + vec.size();

  typedef typename SHARED_VECTOR_TYPE<T>::ShmemAllocator ShmemAllocator;
  typedef typename SHARED_VECTOR_TYPE<T>::SharedVector SharedVector;

  const ShmemAllocator alloc_inst (segment.get_segment_manager());

  segment.construct<SharedVector>
    (obj_name)/*object name*/
    (x_begin     /*first ctor parameter*/,
      y_end     /*second ctor parameter*/,
      alloc_inst /*third ctor parameter*/);

  return 0;
}

// [[Rcpp::export]]
int share_raw(const std::vector<Rbyte>& vec,
  const char* seg_name, const char* obj_name, const bool& overwrite) {
  return share_vector<Rbyte>(vec, seg_name, obj_name, overwrite);
}
