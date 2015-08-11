#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MAMUTE_DIR=$SCRIPT_DIR

TIMESTAMP=BUILD_TIMESTAMP

WEB_INF=/c/git/mamute/src/main/webapp/WEB-INF

java -cp ${WEB_INF}/classes/:${WEB_INF}/lib/* \
    -Ddeploy.timestamp=$TIMESTAMP \
    -Dvraptor.webappdir=${MAMUTE_DIR} \
    ${MAMUTE_OPTS} \
    br.com.caelum.vraptor.server.Main \
	not-grunt