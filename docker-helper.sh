#!/bin/sh

## Script to run additional docker-compose files that specify local services to build or run
## Usage examples:
##   - ./docker-helper.sh --run
##   - ./docker-helper.sh --build
##   - ./docker-helper.sh --build api
##   - ./docker-helper.sh --run api processor

cmd_base="docker-compose -f docker-compose.yaml"
cmd_extra=""
services=""

## Skip first arg since that is either `--build` or `--run`
for service_name in "${@:2}"; do
    services="$service_name ${services}"
    cmd_extra="${cmd_extra} -f docker-compose.$service_name.yaml"
done

if [ "$1" == "--run" ]; then
    cmd="${cmd_base}${cmd_extra} up"
    $cmd
elif [ "$1" == "--build" ]; then
    cmd="${cmd_base}${cmd_extra} up -d --no-deps --build ${services}"
    $cmd
else
    echo 'ERROR: $1 is an unrecognized flag - use either --run or --build'
fi