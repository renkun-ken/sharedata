// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

template <typename T_IN, typename T_OUT>
T_OUT get_shared_vector(const char* seg_name, const char* obj_name) {
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
IntegerVector get_shared_integer_vector(const char* seg_name, const char* obj_name) {
  return get_shared_vector<int, IntegerVector>(seg_name, obj_name);
}

// [[Rcpp::export]]
NumericVector get_shared_numeric_vector(const char* seg_name, const char* obj_name) {
  return get_shared_vector<double, NumericVector>(seg_name, obj_name);
}
