#! /bin/bash

set -e

echo "########## Stopping site..."
ssh nsdateformatter.com -C "ps ax | grep NSDateFormatter | grep -v grep && killall NSDateFormatter || echo 'not running'"

echo "########## Deploying site..."
scp -r Sources nsdateformatter.com:~/nsdateformatter/
scp -r Resources nsdateformatter.com:~/nsdateformatter/
scp Package.swift nsdateformatter.com:~/nsdateformatter/
ssh nsdateformatter.com -C "chmod -R 755 ~/nsdateformatter/Resources"

echo "########## Building site..."

# need to remove tests from package until this spm bug is fixed
# ssh nsdateformatter.com -C "find ~/nsdateformatter/Packages -type d -name 'Tests' | xargs rm -r"

ssh nsdateformatter.com -t -C "source ~/.profile && cd ~/nsdateformatter && swift build --configuration release"

echo "########## Starting site..."
ssh nsdateformatter.com -C "cd ~/nsdateformatter && .build/release/NSDateFormatter &"
