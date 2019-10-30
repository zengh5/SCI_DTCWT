#include <math.h>
#include <stdio.h>

void MIRDWT(double *x, int m, int n, double *h, int lh, int L, double *yl, double *yh);
void bpconv(double *x_out, int lx, double *g0, double *g1, int lh, double *x_inl, double *x_inh);
