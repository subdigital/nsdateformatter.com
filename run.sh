# /bin/bash

# Needs to be run on the server, after site has been compiled

process=NSDateFormatter
configuration=release

set -e

echo "########## Stopping site..."
ps ax | grep $process | grep -v grep && killall $process || echo 'not running'

echo "########## Running server..."
.build/$configuration/$process
