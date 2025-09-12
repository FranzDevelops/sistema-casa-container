#!/bin/bash
set -e

# Ensure the system directory exists before copying
mkdir -p /firebird/system
mkdir -p /firebird/etc

# Copy default config and security database on first run
if [ ! -f /firebird/etc/firebird.conf ]; then
  # Copy security database to the expected location
  cp /usr/local/firebird/skel/security2.fdb /firebird/system/security2.fdb
  # Copy configuration files
  cp -r /usr/local/firebird/skel/etc/* /firebird/etc/
fi

# Ensure isql-fb is executable and in PATH or use its full path
# The executable is usually located at /usr/local/firebird/bin/isql-fb

exec "$@"
