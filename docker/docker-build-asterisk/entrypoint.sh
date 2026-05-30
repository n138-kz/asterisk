#!/bin/bash
set -e

# /etc/squid/squid.conf が存在しない場合にバックアップから復元
if [ ! -f /etc/asterisk/asterisk.conf ]; then
  echo "Config file not found. Restoring from /usr/src/asterisk/configs/samples/..."
  cp /usr/src/asterisk/configs/samples/asterisk.conf /etc/asterisk/
  cp /usr/src/asterisk/configs/samples/modules.conf /etc/asterisk/
  cp /usr/src/asterisk/configs/samples/pjsip.conf /etc/asterisk/
  cp /usr/src/asterisk/configs/samples/extensions.conf /etc/asterisk/
fi

# マウントされたディレクトリの所有権を適切に設定
chown -R asterisk:asterisk /etc/asterisk /var/log/asterisk /var/lib/asterisk /var/spool/asterisk /usr/lib/asterisk

echo "Starting Asterisk..."
exec /usr/sbin/asterisk -f -U asterisk -G asterisk

# # asterisk -h
# Asterisk 23.3.0, Copyright (C) 1999 - 2025, Sangoma Technologies Corporation and others.
# Usage: asterisk [OPTIONS]
# Valid Options:
#    -V              Display version number and exit
#    -C <configfile> Use an alternate configuration file
#    -G <group>      Run as a group other than the caller
#    -U <user>       Run as a user other than the caller
#    -c              Provide console CLI
#    -d              Increase debugging (multiple d's = more debugging)
#    -f              Do not fork
#    -F              Always fork
#    -g              Dump core in case of a crash
#    -h              This help screen
#    -i              Initialize crypto keys at startup
#    -L <load>       Limit the maximum load average before rejecting new calls
#    -M <value>      Limit the maximum number of calls to the specified value
#    -m              Mute debugging and console output on the console
#    -n              Disable console colorization. Can be used only at startup.
#    -p              Run as pseudo-realtime thread
#    -q              Quiet mode (suppress output)
#    -r              Connect to Asterisk on this machine
#    -R              Same as -r, except attempt to reconnect if disconnected
#    -s <socket>     Connect to Asterisk via socket <socket> (only valid with -r)
#    -t              Record soundfiles in /var/tmp and move them where they
#                    belong after they are done
#    -T              Display the time in [Mmm dd hh:mm:ss] format for each line
#                    of output to the CLI. Cannot be used with remote console mode.
# 
#    -v              Increase verbosity (multiple v's = more verbose)
#    -x <cmd>        Execute command <cmd> (implies -r)
#    -X              Enable use of #exec in asterisk.conf
#    -W              Adjust terminal colors to compensate for a light background
