#!/bin/bash
set -Eeo pipefail

if [ "$1" = 'TurtleCoind' ]; then
    rm -f /opt/turtlecoin/p2pstate.bin
fi

exec "$@"
