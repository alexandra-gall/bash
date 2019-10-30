#!/bin/bash
std=$(mktemp)
err=$(mktemp)
echo "1000" > task.txt
count=1000
function Test {
  if [ "$?" -ne $1 ]
  then
    echo "Test failed by return code"
    exit 1
  fi
  STD=`cat $std`
  ERR=`cat $err`
  if [ "$STD" != "$2" ]
  then
    echo "Test failed by stdout"
    exit 1
  fi
  if [ "$ERR" != "$3" ]
  then
    echo "Test failed by stderr"
    exit 1
  fi
  echo "OK"
}
function LoadTest {
  if [ "$?" -ne $1 ]
  then
    echo "Test failed by return code"
    exit 1
  fi
  STD=`cat $std`
  ERR=`cat $err`
  if [ "$STD" != "$2" ]
  then
    echo "Test failed by stdout"
    exit 1
  fi
  if [ "$ERR" != "$3" ]
  then
    echo "Test failed by stderr"
    exit 1
  fi
}
# 1 test: mkdir command
echo "1. mkdir"
if [ -d ~/foo ]
then
  rm -R ~/foo
fi
mkdir ~/foo 1>"$std" 2>"$err"
if ! [ -d ~/foo ]
then
  echo 'Test failed'
  exit 1
fi
Test 0 "" ""
# 2 test: cd command
echo "2. cd"
cd /etc 1>"$std" 2>"$err"
if [ "$PWD" != "/etc" ]
then
  echo 'Test failed'
  exit 1
fi
Test 0 "" ""
cd - 1>"$std" 2>"$err"
# 3 test: echo command
echo "3. echo"
echo "New string" 1>"$std" 2>"$err"
Test 0 "New string" ""
# 4 test: load test echo command
echo "4. echo load test"
for (( i=1; i <= $count; i++ ))
do
  echo "New string" 1>"$std" 2>"$err"
  LoadTest 0 "New string" ""
done
echo "Load test echo command... OK"
# 5 test: pwd command
echo "5. pwd"
pwd 1>"$std" 2>"$err"
Test 0 "$PWD" ""
# 6 test: load test pwd command
echo "6. pwd load test"
for (( i=1; i <= $count; i++ ))
do
  pwd 1>"$std" 2>"$err"
  LoadTest 0 "$PWD" ""
done
echo "Load test pwd command... OK"
# 7 test: mv command
echo "7. mv rename"
mv task.txt renamed.txt 1>"$std" 2>"$err"
if [ -f ./renamed.txt ]
then
  echo "Test passed"
fi
Test 0 "" ""
# 8 test: mv command
echo "8. mv replace"
mv renamed.txt ~/foo 1>"$std" 2>"$err"
  if [ -f ~/foo/renamed.txt ]
then
  echo "Test passed"
fi
Test 0 "" ""
# 9 test: ls command
echo "9. ls"
ls ~/foo 1>"$std" 2>"$err"
Test 0 "renamed.txt" ""
# 10 test: load test ls command
echo "10. ls load test"
for (( i=1; i <= $count; i++ ))
do
  ls ~/foo 1>"$std" 2>"$err"
  LoadTest 0 "renamed.txt" ""
done
echo "Load test ls command... OK"
# 11 test: cp command
echo "11. cp"
cp /etc/passwd ~/foo/ 1>"$std" 2>"$err"
if [ -f ~/foo/passwd ]
then
  echo 'Test passed'
fi
Test 0 "" ""
rm ~/foo/passwd
# 12 test: touch command
echo "12. touch"
touch ~/foo/foo.txt 1>"$std" 2>"$err"
if [ -f ~/foo/foo.txt ]
then
  echo 'Test passed'
fi
Test 0 "" ""
# 13 test: cat command
echo "13. cat"
echo "String" > ~/foo/foo.txt
cat ~/foo/foo.txt 1>"$std" 2>"$err"
Test 0 "String" ""
# 14 test: load test cat command
echo "14. cat load test"
for (( i=1; i <= $count; i++ ))
do
  cat ~/foo/foo.txt 1>"$std" 2>"$err"
  LoadTest 0 "String" ""
done
echo "Load test cat command... OK"
# 15 test: rm command
echo "15. rm"
rm ~/foo/foo.txt 1>"$std" 2>"$err"
Test 0 "" ""
# 16 test: rm command (no such file or directory)
echo "16. rm (no such file)"
rm ~/foo/foo.txt 1>"$std" 2>"$err"
Test 1 "" "rm: cannot remove '/home/alexandra/foo/foo.txt': No such file or directory"
# 17 test: whoami command
echo "17. whoami"
whoami 1>"$std" 2>"$err"
Test 0 "$USER" ""
# 18 test: load test whoami command
echo "18. whoami load test"
for (( i=1; i <= $count; i++ ))
do
  whoami 1>"$std" 2>"$err"
  LoadTest 0 "$USER" ""
done
echo "Load test whoami command... OK"
# 19 test: uname command
echo "19. uname"
uname 1>"$std" 2>"$err"
Test 0 "Linux" ""
# 20 test: load test uname command
echo "20. uname load test"
for (( i=1; i <= $count; i++ ))
do
  uname 1>"$std" 2>"$err"
  LoadTest 0 "Linux" ""
done
echo "Load test uname command... OK"
rm $std
rm $err
rm -R ~/foo
