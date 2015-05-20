// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

template <typename T_IN, typename T_OUT>
T_OUT clone_shared_vector(const char* seg_name, const char* obj_name) {
  using namespace boost::interprocess;
  //Open the managed segment
  managed_shared_memory segment(open_only, seg_name);
  typedef typename SHARED_VECTOR_TYPE<T_IN>::SharedVector SharedVector;
  //Find the vector using the c-string name
  SharedVector *sv = segment.find<SharedVector>(obj_name).first;
  T_OUT v(sv->begin(), sv->end());
  return v;
}

// [[Rcpp::export]]
RawVector clone_shared_raw(const char* seg_name, const char* obj_name) {
  return clone_shared_vector<Rbyte, RawVector>(seg_name, obj_name);
}
