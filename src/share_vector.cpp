// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

// [[Rcpp::export]]
int share_int(const std::vector<int>& vec, const char* seg_name, const char* obj_name) {
  using namespace boost::interprocess;

  shared_memory_object::remove(seg_name);

  managed_shared_memory segment(create_only,
    seg_name, vec.size() * sizeof(int) + 1024);

  const int *x_begin = &vec.front();
  const int *y_end = x_begin + vec.size();

  const ShmemAllocator alloc_inst (segment.get_segment_manager());

  SharedVector *sv =
    segment.construct<SharedVector>
    (obj_name)/*object name*/
    (x_begin     /*first ctor parameter*/,
      y_end     /*second ctor parameter*/,
      alloc_inst /*third ctor parameter*/);

  return 0;
}
