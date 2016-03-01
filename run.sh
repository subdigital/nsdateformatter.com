# /bin/bash

# Needs to be run on the server, after site has been compiled

set -e

echo "########## Stopping site..."
ps ax | grep $process | grep -v grep && killall $process || echo 'not running'

echo "########## Running server..."
.build/release/NSDateFormatter
