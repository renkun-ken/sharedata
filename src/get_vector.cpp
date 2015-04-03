// [[Rcpp::depends(BH)]]
#include <vector>
#include <Rcpp.h>
#include "types.h"

using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector get_shared_int(const char* seg_name, const char* obj_name) {
  using namespace boost::interprocess;
  //Open the managed segment
  managed_shared_memory segment(open_only, seg_name);

  //Find the vector using the c-string name
  SharedVector *sv = segment.find<SharedVector>(obj_name).first;

  IntegerVector v(sv->begin(), sv->end());

  return v;
}
