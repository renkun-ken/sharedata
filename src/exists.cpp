// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

//[[Rcpp::export]]
bool exists_shared_object(const char* seg_name) {
  using namespace boost::interprocess;
  try {
    managed_shared_memory segment(open_only, seg_name);
  } catch(...) {
    return false;
  }
  return true;
}
