// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

//[[Rcpp::export]]
bool remove_shared_object(const char* seg_name) {
  boost::interprocess::shared_memory_object::remove(seg_name);
  return true;
}
