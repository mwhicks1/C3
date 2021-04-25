void f(int *n) {
  int *x = _Assume_bounds_cast<_Array_ptr<int>>(n,bounds(p,p+5));
  int *y = _Assume_bounds_cast<_Ptr<int>>(n);
}
