#! /bin/bash

set -e

swift build --configuration release

# need to remove tests from package until this spm bug is fixed
find Packages -type d -name "Tests" | xargs -n 1 rm -r
