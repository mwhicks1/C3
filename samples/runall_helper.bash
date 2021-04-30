# To be `source`d by {Olden,ptrdist}/runall.sh .

# I currently keep `clang` off my default $PATH to ensure that if I run a tool
# that assumes `clang` is either regular C or Checked C `clang`, I get an error
# and can ensure I select the correct one rather than risking silently incorrect
# behavior. Others might consider my setup silly, but hopefully they don't mind
# this code to check up front. ~ Matt 2021-04-29
if ! type clang &>/dev/null; then
  echo >&2 'Error: Please have the regular C `clang` on your $PATH before running the C3 sample tests.'
  exit 1
fi

if ! [ -x "$CHECKEDCCLANG" ]; then
  echo >&2 'Error: Please set $CHECKEDCCLANG to the path to the Checked C clang before running the C3 sample tests.'
  exit 1
fi

for T in $TARGETS; do
(
  cd $T
  echo ===== $T =====
  make clean
  echo == Making $T with Checked C
  make CC=$CHECKEDCCLANG
  echo == Reverting $T, building result
  make ${T}_c3
  echo == Testing
  make test
)
done
