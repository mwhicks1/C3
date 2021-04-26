#include <stdio.h>
#include <stdchecked.h>

int main(int argc, char** argv : itype(_Array_ptr<_Nt_array_ptr<char>>) count(argc)) {
  checked{
    int arr checked[5]  = { 0, 1, 2, 3, 4 };
    ptr<ptr<int>> q;
  }

  int arr checked[5]  = { 0, 1, 2, 3, 4 };
  ptr<ptr<int>> q;
  array_ptr <int > current : bounds (start , end ) = start;
  dynamic_check(1 == 1);
  return 0;
}
