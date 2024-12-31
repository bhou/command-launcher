#!/bin/bash

# availeble environment varibale
# CL_PATH: the path of the command launcher binary
# CL_HOME: the path of the command launcher home directory
# OUTPUT_DIR: the output folder
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# clean up the dropin folder
rm -rf $CL_HOME/dropins
mkdir -p $CL_HOME/dropins

echo "> test download default remote command"
RESULT=$($OUTPUT_DIR/cl config command_repository_base_url https://raw.githubusercontent.com/criteo/command-launcher/main/examples/remote-repo)
RESULT=$($OUTPUT_DIR/cl)

echo "* should have hello command installed"
echo "$RESULT" | grep -q "hello"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - hello command should exist"
  exit 1
fi

echo "* should contain default remote registry"
RESULT=$($CL_PATH remote list)
echo "$RESULT"
echo "$RESULT" | grep -q "default         : https://raw.githubusercontent.com/criteo/command-launcher/main/examples/remote-repo"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should contain default remote registry"
  exit 1
fi


echo "> test add extra remote registry"
RESULT=$($CL_PATH remote add extra1 https://raw.githubusercontent.com/criteo/command-launcher/main/test/remote-repo)
RESULT=$($CL_PATH remote list)

echo "* should contain default remote registry"
echo "$RESULT" | grep -q "default         : https://raw.githubusercontent.com/criteo/command-launcher/main/examples/remote-repo"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should contain default remote registry"
  exit 1
fi

echo "* should contain extra remote registry"
echo "$RESULT" | grep -q "extra1          : https://raw.githubusercontent.com/criteo/command-launcher/main/test/remote-repo"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should contain extra remote registry"
  exit 1
fi

echo "* should contain extra command: 'bonjour'"
RESULT=$($CL_PATH)
echo "$RESULT" | grep -q "bonjour"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should contain extra command 'bonjour'"
  exit 1
fi

echo "* should contain auto-renamed command: 'hello@@command-launcher-demo@extra1'"
echo "$RESULT" | grep -q "hello@@command-launcher-demo@extra1"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should contain auto-renamed command 'hello@@command-launcher-demo@extra1'"
  exit 1
fi

echo "* should be able to run 'hello@@command-launcher-demo@extra1'"
RESULT=$($CL_PATH hello@@command-launcher-demo@extra1)
echo "$RESULT" | grep -q "Hello World v2!"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should successfully run command 'hello@@command-launcher-demo@extra1'"
  exit 1
fi

echo "* should be able to run 'hello'"
RESULT=$($CL_PATH hello)
echo "$RESULT" | grep -q "Hello World!"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should successfully run command 'hello'"
  exit 1
fi

echo "> test sync policy"

echo "* should NOT have the sync.timestamp file"
RESULT=$(ls $CL_HOME/extra1 | grep -q "sync.timestamp")
if [ $? -eq 0 ]; then
  echo "KO - should NOT have the sync.timestamp file"
  exit 1
else
  echo "OK"
fi
# change the extra remote's sync policy to 'weekly'
sed -i -e 's/always/weekly/g' $CL_HOME/config.json

# now remove one package from local repository and run command launcher to sync
$CL_PATH config command_update_enabled true
rm -rf $CL_HOME/extra1/command-launcher-demo

echo "* should install new package"
RESULT=$($CL_PATH)
echo "$RESULT" | grep -q "Update done! Enjoy coding!"
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should install new package"
  exit 1
fi

echo "* should have the sync.timestamp file after sync"
RESULT=$(ls $CL_HOME/extra1 | grep -q "sync.timestamp")
if [ $? -eq 0 ]; then
  echo "OK"
else
  echo "KO - should NOT have the sync.timestamp file"
  exit 1
fi

# now remove the package again, should not install the package again
rm -rf $CL_HOME/extra1/command-launcher-demo
echo "* should NOT install new package"
RESULT=$($CL_PATH)
echo "$RESULT" | grep -q "Update done! Enjoy coding!"
if [ $? -eq 0 ]; then
  echo "KO - should NOT install new package"
  exit 1
else
  echo "OK"
fi

# reset the config
$CL_PATH config command_update_enabled false

echo "> test delete extra remote registry"
RESULT=$($CL_PATH remote delete extra1)
RESULT=$($CL_PATH remote list)
echo "$RESULT" | grep -q "default         : https://raw.githubusercontent.com/criteo/command-launcher/main/examples/remote-repo"
if [ $? -eq 0 ]; then
  # ok
  echo "OK"
else
  echo "KO - should contain default remote registry"
  exit 1
fi

echo "* should NOT contain default remote registry"
echo "$RESULT" | grep -q "extra1          : https://raw.githubusercontent.com/criteo/command-launcher/main/test/remote-repo"
if [ $? -eq 0 ]; then
  echo "KO - should NOT contain extra remote registry"
  exit 1
else
  echo "OK"
fi

echo "* should NOT contain extra command"
RESULT=$($CL_PATH)
echo "$RESULT" | grep -q "bonjour"
if [ $? -eq 0 ]; then
  echo "KO - should NOT contain extra command 'bonjour'"
  exit 1
else
  echo "OK"
fi


