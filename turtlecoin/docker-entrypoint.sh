#!/bin/bash
set -Eeo pipefail

if [ "$1" = 'TurtleCoind' ]; then
    rm -f /data/p2pstate.bin && echo "deleted p2pstate.bin"
fi

exec "$@"
