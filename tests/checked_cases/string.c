void foo(void) {
  char *s = "hello \"as if\" he said";
  _Nt_array_ptr<char> s2 = "hello \"as \
    if\" he said";
  char *p = "_Ptr<int> is in a string---should stay!";
  char x = '\'';
  char y = '\"';
  _Ptr<int> p = 0;
}
