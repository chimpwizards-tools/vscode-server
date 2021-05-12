#!/bin/bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

if [[ "$STARTUP_SCRIPT" != "" ]]; then
    echo "Custom script initialization"
    curl -o- $STARTUP_SCRIPT| bash
fi

echo "Running server..."
sh /usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 .