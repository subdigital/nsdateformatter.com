#! /bin/bash

set -e

host=nsdateformatter.com
app_dir=/srv/nsdateformatter
process=NSDateFormatter
configuration=release

# commented out until we can also run the site in daemonize mode.
# echo "########## Stopping site..."
# ssh nsdateformatter.com -C "ps ax | grep $process | grep -v grep && killall $process || echo 'not running'"

echo "########## Deploying site..."
scp -r Sources $host:$app_dir
scp -r Resources $host:$app_dir
scp Package.swift $host:$app_dir
ssh $host -C "chmod -R 644 $app_dir/Resources/*"

echo "########## Building site..."

# if you get an error building, you may need to manually SSH in and remove Test dirs from the Packages folder
# until that spm bug is fixed
ssh $host -t -C "source ~/.profile && cd $app_dir && swift build --configuration $configuration"

echo "########## Starting site..."
echo "(please start site manually with run.sh until --daemonize is supported by Frank)"
# ssh $host -C "cd $app_dir && .build/$configuration/$process &"
