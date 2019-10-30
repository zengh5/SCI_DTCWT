#include <math.h>
#include <stdio.h>

void MRDWT(double *x, int m, int n, double *h, int lh, int L, double *yl, double *yh);
void fpconv(double *x_in, int lx, double *h0, double *h1, int lh, double *x_outl, double *x_outh);
