// [[Rcpp::depends(RcppParallel)]]
#define STRICT_R_HEADERS
#include <RcppParallel.h>
#include <Rcpp.h>
using namespace RcppParallel;
using namespace Rcpp;

const double earth = 6378137.0;

double dist_haversine(double x1, double y1, double x2, double y2) {

  double sxd = sin((x2 - x1) * M_PI / 360.0);
  double syd = sin((y2 - y1) * M_PI / 360.0);
  double cosy1 = cos(y1 * M_PI / 180.0);
  double cosy2 = cos(y2 * M_PI / 180.0);


  double d = syd * syd + cosy1 * cosy2 * sxd *sxd;

  d = 2.0 * earth * asin(sqrt(d));

  return d;

}

double dist_vincenty(double x1, double y1, double x2, double y2) {
  double xd = (x2 - x1) * M_PI / 180.0;
  double cxd = cos(xd);
  double cosy1 = cos(y1 * M_PI / 180.0);
  double cosy2 = cos(y2 * M_PI / 180.0);
  double siny1 = sin(y1 * M_PI / 180.0);
  double siny2 = sin(y2 * M_PI / 180.0);

  double n1 = cosy2 * sin (xd); // first term of numerator
  double n2 = cosy1 * siny2 - siny1 * cosy2 * cxd;
  double numerator = n1 * n1 + n2 * n2;
  double denominator = siny1 * siny2 + cosy1 * cosy2 * cxd;
  double d = earth * atan2 (sqrt (numerator), denominator);
  return d;
}

struct myDistanceMatrix : public Worker {
  RMatrix<double> x;
  RMatrix<double> y;
  RMatrix<double> rmat;
  int measure;

  myDistanceMatrix(NumericMatrix x, NumericMatrix y, NumericMatrix rmat, int measure)
    : x(x), y(y), rmat(rmat), measure(measure) {}

  void operator()(std::size_t begin, std::size_t end) {
    for (std::size_t i = begin; i < end; i++) {
      for (std::size_t j = 0; j < y.nrow(); j++) {
        double dist = 0.0;
        if (measure == 1) {
          dist = dist_haversine(x(i, 0), x(i, 1), y(j, 0), y(j, 1));
        } else if (measure == 2) {
          dist = dist_vincenty(x(i, 0), x(i, 1), y(j, 0), y(j, 1));
        }
        //double dist = dist_haversine(x(i, 0), x(i, 1), y(j, 0), y(j, 1));
        rmat(i, j) = dist;
      }
    }
  }
};

// [[Rcpp::export]]
NumericMatrix geodistpar_cpp(NumericMatrix x, NumericMatrix y, int measure) {
  NumericMatrix rmat(x.nrow(), y.nrow());

  myDistanceMatrix my_distance_matrix(x, y, rmat, measure);

  parallelFor(0, rmat.nrow(), my_distance_matrix, 1);

  return rmat;
}
