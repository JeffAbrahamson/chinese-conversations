#!/bin/bash

# This file is copy-pasted from elsewhere.  It expresses intent, but isn't correct for this repo.
# Codex: your job is to generate a compose.yml and a Dockerfile to support local development and testing.


action="$1"
shift
case "$action" in
    run)
        docker compose up --build streamer-run
        ;;
    test)
        docker compose run --build --rm streamer-test "$@"
        ;;
    sh)
        docker compose up -d --build streamer-sh
        docker compose exec streamer-sh /bin/bash

        echo "Checking if other shells are running..."
        num_shells=$(docker compose exec streamer-sh pgrep bash | wc -l)
        if [ "$num_shells" -ne 0 ]; then
            echo "${num_shells} still running."
        else
            echo "No more shells detected, stopping container..."
            docker compose stop streamer-sh
        fi
        ;;
    claude)
        docker compose up -d --build streamer-claude
        docker compose exec streamer-claude /bin/bash

        echo "Checking if other shells are running..."
        num_shells=$(docker compose exec streamer-claude pgrep bash | wc -l)
        if [ "$num_shells" -ne 0 ]; then
            echo "${num_shells} still running."
        else
            echo "No more shells detected, stopping container..."
            docker compose stop streamer-claude
        fi
        ;;
    down)
        docker compose down
        ;;
    *)
        echo "Usage: $0 {run|test|sh|claude|down}"
        echo ""
        echo "  run    - Build and run the streamer application"
        echo "  test   - Run the test suite"
        echo "  sh     - Start an interactive shell"
        echo "  claude - Start an interactive shell with Claude Code available"
        echo "  down   - Stop all containers"
        exit 1
        ;;
esac
