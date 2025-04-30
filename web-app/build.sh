#!/bin/bash

# Get git information
GIT_COMMIT_HASH=$(git rev-parse HEAD)
GIT_COMMIT_MESSAGE=$(git log -1 --pretty=%B)

# Export as environment variables
export GIT_COMMIT_HASH
export GIT_COMMIT_MESSAGE

# Build and run the docker container
# Use --build to rebuild the image
# Use -d to run in detached mode (optional)
docker compose up --build "$@"

# If you only want to build without running, use:
# docker compose build "$@"