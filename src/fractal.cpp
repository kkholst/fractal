////////////////////////////////////////////////////////////////
// Copyright (c) Klaus K. Holst, 2020-10-18		      //
// All rights reserved.					      //
// 							      //
// Redistribution and use in source and binary forms, with or //
// without modification, are permitted			      //
////////////////////////////////////////////////////////////////

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::plugins(cpp11)]]
#include <RcppArmadillo.h>
#include <complex>
#include <cmath>
#include <vector>
using namespace Rcpp;
using Complex = std::complex<double>;
using lvector = std::vector<long double>;

unsigned julia1(long double re, long double im, Complex c,
		unsigned maxIter, long double exponent,
		double escape) {
  std::complex<long double> z(re,im);
   for (unsigned i=0; i<maxIter; i++) {
     if (exponent==2) {
       // calculate f^(n)(z)
       // f(z) = z*z + c
       long double zre_square = re*re;
       long double zim_square = im*im;
       if (escape>0) {
	 if ((zre_square+zim_square)>escape) return(i);
       } else if (!std::isfinite(zre_square+zim_square)) return(i);
       // (a+bi)^2 = a^2 - b^2 + 2abi
       im = 2*re*im + std::imag(c);
       re = zre_square - zim_square + std::real(c);
     } else {
       z = std::pow(z, exponent) + (std::complex<long double>)(c);
       if (!std::isfinite(std::abs(z))) return(i);
     }
   }
   return(maxIter);
}

lvector linspace(long double from, long double to, unsigned dim) {
  lvector x(dim);
  for (unsigned i=0; i<dim; i++) {
    x[i] = from + (to-from)/(double)dim*i;
  }
  return(x);
}

// [[Rcpp::export(name=".mandelbrot")]]
Rcpp::List mandelbrot(unsigned dim=500,
		      unsigned maxIter=256,
		      long double R=1.0,
		      long double cx=0.0,
		      long double cy=0.0,
		      double exponent=2.0,
		      double escape=0.0) {
  lvector xr = linspace(-R+cx, R+cx, dim);
  lvector yr = linspace(-R+cy, R+cy, dim);
  arma::mat res(dim, dim);
  for (unsigned x=0; x<dim; x++) {
    for (unsigned y=0; y<dim; y++) {
      res(x,y) = julia1(0.0, 0.0, Complex(xr[x], yr[y]), maxIter, exponent, escape);
    }
  }
  return( Rcpp::List::create(Rcpp::Named("x")=xr,
			     Rcpp::Named("y")=yr,
			     Rcpp::Named("z")=res) );
}

// [[Rcpp::export(name=".julia")]]
Rcpp::List julia(std::complex<double> c,
		 unsigned dim=500,
		 unsigned maxIter=256,
		 long double R=0.0,
		 long double cx=0.0,
		 long double cy=0.0,
		 long double exponent=2.0,
		 double escape=0.0) {
     if (R<=0.0) {
        R = (1+std::sqrt(1+4*std::abs(c)))/2;
     }
     lvector xr = linspace(-R+cx, R+cx, dim);
     lvector yr = linspace(-R+cy, R+cy, dim);
     arma::mat res(dim, dim);
     for (unsigned x=0; x<dim; x++) {
        for (unsigned y=0; y<dim; y++) {
	  res(x,y) = julia1(xr[x], yr[y], c, maxIter, exponent, escape);
        }
     }
     return( Rcpp::List::create(Rcpp::Named("x")=xr,
				Rcpp::Named("y")=yr,
				Rcpp::Named("z")=res) );
}
