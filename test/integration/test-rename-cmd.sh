#!/bin/bash

# availeble environment varibale
# CL_PATH: the path of the command launcher binary
# CL_HOME: the path of the command launcher home directory
# OUTPUT_DIR: the output folder
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# clean up the dropin folder
rm -rf $CL_HOME/dropins
mkdir -p $CL_HOME/dropins

# copy the example to the dropin folder for the test
cp -R $SCRIPT_DIR/../packages-src/bonjour $CL_HOME/dropins

# run command launcher
echo "> test rename command should exist"
RESULT=$($CL_PATH)

echo "$RESULT" | grep 'rename'
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should have rename command at root"
  exit 1
fi

echo "> test rename command autocompletion"
RESULT=$($CL_PATH __complete rename "")
echo "$RESULT" | grep 'bonjour@@bonjour@dropin'
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should auto-complete install command full name"
  exit 1
fi

echo "> test rename command"
RESULT=$($CL_PATH rename bonjour@@bonjour@dropin hi)
RESULT=$($CL_PATH)
echo "$RESULT" | grep 'hi'
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should have 'hi' command"
  exit 1
fi

RESULT=$($CL_PATH hi)
echo "$RESULT" | grep 'bonjour!'
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should be able to run 'hi' command"
  exit 1
fi

echo "> test delete renamed command"
RESULT=$($CL_PATH rename --delete bonjour@@bonjour@dropin)
RESULT=$($CL_PATH)
echo "$RESULT" | grep 'hi'
if [ $? -eq 0 ]; then
  echo "KO - should NOT have 'hi' command"
  exit 1
else
  echo "OK"
fi

echo "$RESULT" | grep 'bonjour'
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should have bonjour command"
  exit 1
fi







