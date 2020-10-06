#!/bin/sh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
echo "Running server..."
sh /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 .