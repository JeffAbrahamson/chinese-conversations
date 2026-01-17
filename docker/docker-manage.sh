#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

action="$1"
shift || true

case "$action" in
    run)
        docker compose up --build run
        ;;
    test)
        docker compose run --build --rm test "$@"
        ;;
    sh)
        docker compose up -d --build sh
        docker compose exec sh /usr/local/bin/entrypoint.sh /bin/bash

        echo "Checking if other shells are running..."
        num_shells=$(docker compose exec sh ps -eo tty,comm | awk '$1 ~ /^pts\// && $2=="bash" {print $1}' | sort -u | wc -l)
        if [ "$num_shells" -ne 0 ]; then
            echo "${num_shells} still running."
        else
            echo "No more shells detected, stopping container..."
            docker compose stop sh
        fi
        ;;
    claude)
        # The following fussing about is because /usr/local/bin/claude
        # is an interpreted file (starts with #!), which is somehow
        # leading to HOME being set to the real value for the uid
        # invoked by gosu in entrypoint.sh.
        #
        # The hacky workaround here is that entrypoint.sh explicitly
        # detects that we want to run claude, then runs directly the
        # node file to which /usr/local/bin/claude points.
        #
        # This is obviously fragile to something about the claude
        # installation changing.  If that happens, we should change to
        # running bash, check what's being executed, and then execute
        # that instead.  It's also possible that future iterations of
        # something will obviate the need for this hack.

        docker compose run --rm --build claude claude
        ;;
    down)
        docker compose down
        ;;
    *)
        echo "Usage: $0 {run|test|sh|claude|down}"
        echo ""
        echo "  run    - Start the wrangler dev server (port 8787)"
        echo "  test   - Run the test suite"
        echo "  sh     - Start an interactive development shell (shared container)"
        echo "  claude - Start Claude Code (one-shot container)"
        echo "  down   - Stop all containers"
        exit 1
        ;;
esac
