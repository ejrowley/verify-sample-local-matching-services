#!/usr/bin/env bash
set -e

./test_ruby.sh
./test_csharp.sh
./test_nancy.sh
./test_haskell.sh
./test_visualbasic.sh

echo "SUCCESS!"
