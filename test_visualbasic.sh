#!/usr/bin/env bash
set -e

function cleanup() {
    kill "$(<./visualbasic/visualbasic_lms.pid)" && rm -f ./visualbasic/visualbasic_lms.pid
}

cd "$(dirname "$0")"

(cd visualbasic
 xbuild /p:VbcToolExe=$(which vbnc)
 mono ./bin/Debug/lms.exe&
 echo $! > visualbasic_lms.pid)

trap cleanup EXIT

(cd local-matching-service-tests
mvn test -DMATCHING_URL=http://localhost:8080/visualbasic/matching-service -DUSER_ACCOUNT_CREATION_URL=http://localhost:8080/visualbasic/account-creation)



