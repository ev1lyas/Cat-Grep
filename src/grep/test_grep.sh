COUNTER_SUCCESS=0
COUNTER_FAIL=0
DIF_RES=""
TC_NAME=""
FLAGS=""
PATTERN=""
FILE=""
TEST_CASE=""

echo "Somebody once told me the world is gonna roll me
I ain't the sharpest tool in the shed
She was looking kind of dumb with her finger and her thumb
In the shape of an \"L\" on her forehead
Well the years start coming and they don't stop coming
Fed to the rules and I hit the ground running
Didn't make sense not to live for fun
Your brain gets smart but your head gets dumb
So much to do, so much to see
So what's wrong with taking the back streets?
You'll never know if you don't go
You'll never shine if you don't glow
Hey now, you're an all-star, get your game on, go play
Hey now, you're a rock star, get the show on, get paid
And all that glitters is gold
Only shooting stars break the mold
It's a cool place and they say it gets colder
You're bundled up now, wait 'til you get older
But the meteor men beg to differ
Judging by the hole in the satellite picture
The ice we skate is getting pretty thin
The water's getting warm so you might as well swim
My world's on fire, how about yours?
That's the way I like it and I'll never get bored
" > lyrics.txt

echo "Buddy, you're a boy, make a big noise
Playing in the street, gonna be a big man someday
You got mud on your face, you big disgrace
Kicking your can all over the place, singin'
We will, we will rock you
We will, we will rock you
Buddy, you're a young man, hard man
Shouting in the street, gonna take on the world someday
You got blood on your face, you big disgrace
Waving your banner all over the place
We will, we will rock you, sing it!
We will, we will rock you
Buddy, you're an old man, poor man
Pleading with your eyes, gonna make you some peace someday
You got mud on your face, big disgrace
Somebody better put you back into your place
We will, we will rock you, sing it
We will, we will rock you, everybody
We will, we will rock you, hmm
We will, we will rock you
Alright" > lyrics2.txt

function clear_vars() {
  TC_NAME=""
  FLAGS=""
  PATTERN=""
  FILE=""
  TEST_CASE=""
}

function run_utils() {
  $TEST_CASE > orig_$TC_NAME.log
  ./s21_$TEST_CASE > s21_$TC_NAME.log
}

function compare_results() {
  DIF_RES="$(diff -s orig_$TC_NAME.log s21_$TC_NAME.log)"

  if [ "$DIF_RES" == "Files orig_$TC_NAME.log and s21_$TC_NAME.log are identical" ]
    then
      echo "Test:$TC_NAME: \033[05m SUCCESS\033[33m"
      (( COUNTER_SUCCESS++ ))

      echo "" >> main_grep_report.log
      echo "┌──────────────────────────────────────────────────────────────────" >> main_grep_report.log
      echo "│ Test:$TC_NAME:	  Passed" >> main_grep_report.log
      echo "└──────────────────────────────────────────────────────────────────" >> main_grep_report.log
      echo "orig: $TEST_CASE" >> main_grep_report.log
      $TEST_CASE >> main_grep_report.log
      echo "-------------------------------------------------------------------" >> main_grep_report.log
      echo "s21_: ./s21_$TEST_CASE" >> main_grep_report.log
      ./s21_$TEST_CASE >> main_grep_report.log
      echo "-------------------------------------------------------------------" >> main_grep_report.log
    else
      echo  "Test:$TC_NAME: \033[31m❌  Failed\033[0m"
      (( COUNTER_FAIL++ ))

      echo "" >> main_grep_report.log
      echo "┌──────────────────────────────────────────────────────────────────" >> main_grep_report.log
      echo "│ Test:$TC_NAME:	❌  Failed" >> main_grep_report.log
      echo "└──────────────────────────────────────────────────────────────────" >> main_grep_report.log
      echo "orig: $TEST_CASE" >> main_grep_report.log
      $TEST_CASE >> main_grep_report.log
      echo "-------------------------------------------------------------------" >> main_grep_report.log
      echo "s21_: ./s21_$TEST_CASE" >> main_grep_report.log
      ./s21_$TEST_CASE >> main_grep_report.log
      echo "-------------------------------------------------------------------" >> main_grep_report.log
      echo "diff -s orig_$TC_NAME.log s21_$TC_NAME.log" >> main_grep_report.log
      echo "$DIF_RES" >> main_grep_report.log
      echo "-------------------------------------------------------------------" >> main_grep_report.log
  fi
}

function run_test_case() {
  run_utils
  compare_results
}

#rm *.log
touch main_grep_report.log
touch pattern.file
touch empty.file
clear

echo "-------------------------------------------------------------------" >> main_grep_report.log
echo "---------------REPORT-OF-FUNCTIONAL-TEST-S21_GREP------------------" >> main_grep_report.log
echo "-------------------------------------------------------------------" >> main_grep_report.log




#-------------------------------------------------------------------
clear_vars
TC_NAME="GE1S"
FLAGS="-e"
PATTERN="rock"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GE2S"
FLAGS="-e"
PATTERN="me"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GE4M"
FLAGS="-e"
PATTERN="rock"
FILE="lyrics.txt "
TEST_CASE="grep $FLAGS $PATTERN $FILE $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GI1S"
FLAGS="-i"
PATTERN="Your"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GV1S"
FLAGS="-v"
PATTERN="me"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GC1S"
FLAGS="-c"
PATTERN="me"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GL1S"
FLAGS="-l"
PATTERN="back"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GL2M"
FLAGS="-l"
PATTERN="rock"
FILE="lyrics.txt lyrics2.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GL3M"
FLAGS="-l"
PATTERN="back"
FILE="lyrics.txt lyrics2.txt empty.file"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GN1S"
FLAGS="-n"
PATTERN="rock"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GN2S"
FLAGS="-n"
PATTERN="me"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GN3M"
FLAGS="-n"
PATTERN="me"
FILE="lyrics.txt lyrics2.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GN4M"
FLAGS="-n"
PATTERN="me"
FILE="lyrics.txt lyrics2.txt empty.file"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GH1S"
FLAGS="-h"
PATTERN="rock"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GH2S"
FLAGS="-h"
PATTERN="me"
FILE="lyrics.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GH3M"
FLAGS="-h"
PATTERN="me"
FILE="lyrics.txt lyrics2.txt"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GH4M"
FLAGS="-h"
PATTERN="me"
FILE="lyrics.txt lyrics2.txt empty.file"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------
clear_vars
TC_NAME="GS1S"
FLAGS="-s"
PATTERN="rock"
FILE="nonexistent.file"
TEST_CASE="grep $FLAGS $PATTERN $FILE"
run_test_case
#-------------------------------------------------------------------



echo "SUCCESS: $COUNTER_SUCCESS"
echo "FAIL: $COUNTER_FAIL"

echo "" >> main_grep_report.log
echo "---------------------------SUMMARY---------------------------------" >> main_grep_report.log
echo "SUCCESS: $COUNTER_SUCCESS" >> main_grep_report.log
echo "FAIL: $COUNTER_FAIL" >> main_grep_report.log
echo "-------------------------------------------------------------------" >> main_grep_report.log

if [ -d logs ]; then
  rm -rf ./logs/
fi

if ! [ -d logs ]; then
  mkdir ./logs/
fi

mv ./*.log ./logs/

rm *.file lyrics.txt lyrics2.txt