#!/usr/bin/env bash

set -e

lang="nancy"
base="/${lang}"
port=9991

function cleanup {
    docker stop verify_sample_lms_${lang}
    docker rm -f verify_sample_lms_${lang}
}

docker build -t verify_sample_lms/${lang} ${lang}
docker run -d --name verify_sample_lms_${lang} -p ${port}:${port} verify_sample_lms/${lang}

trap cleanup EXIT

cd "$(dirname "$0")"

until docker logs verify_sample_lms_${lang} |grep -m 1 'Starting local matching service'; do sleep 0.5; done

(cd local-matching-service-tests
mvn test -DMATCHING_URL=http://localhost:${port}${base}/matching-service -DUSER_ACCOUNT_CREATION_URL=http://localhost:${port}${base}/account-creation)



