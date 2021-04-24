void f(int *n) {
  int *x = _Assume_bounds_cast<int>(n,bounds(p,p+5));
  int *y = _Assume_bounds_cast<int>(n);
}
