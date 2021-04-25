void foo(void) {
  _Ptr<int(unsigned int)> mapfunc = 0;
  // should translate to 
  // int (*mapfunc)(unsigned int) = 0;
}
