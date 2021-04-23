#define UncheckedPtrInit(type, variable, init) \
  type variable = 0; \
  _Unchecked { variable = init; }
#define UncheckedBoundsInit(type, variable, b, init) \
  type variable : b = 0; \
  _Unchecked { variable = init; }
