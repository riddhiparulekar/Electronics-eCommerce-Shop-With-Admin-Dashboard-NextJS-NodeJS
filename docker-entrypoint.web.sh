#!/bin/sh

# This script is executed as the entrypoint of the web container.
#stop execution if any command fails
set -e

#check if the public directory is empty, if so copy the contents of public-seed to public
if [ -z "$(ls -A ./public 2>/dev/null)" ]; then
  cp -a ./public-seed/. ./public/
fi

exec "$@"