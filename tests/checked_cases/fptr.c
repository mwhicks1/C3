void foo(void) {
  _Ptr<int(unsigned int)> mapfunc = 0;
  _Ptr<int(int)> mapfunc2 = 0;
  _Ptr<int(volatile unsigned int)> mapfunc3 = 0;
  _Ptr<int(volatile unsigned int)> mapfunc4 = 0;
  _Ptr<const int(volatile unsigned int)> mapfunc5 = 0;
  // should translate to 
  // int (*mapfunc)(unsigned int) = 0;
}
