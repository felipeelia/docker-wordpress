#!/bin/bash
set -euo pipefail

! /usr/local/bin/wp-cli.phar cli update --yes

if [[ -v XDEBUG ]] && [ "$XDEBUG" = "true" ];
then
	echo "Using XDEBUG";

    inifile="/usr/local/etc/php/conf.d/pecl-xdebug.ini"
    extfile="$(find /usr/local/lib/php/extensions/ -name xdebug.so)";
    remote_port="${XDEBUG_IDEKEY:-9000}";
    idekey="${XDEBUG_IDEKEY:-xdbg}";

    if [ -f "$extfile" ] && [ ! -f "$inifile" ];
    then
        {
            echo "[Xdebug]";
            echo "zend_extension=${extfile}";
            echo "xdebug.idekey=${idekey}";
            echo "xdebug.remote_enable=1";
            echo "xdebug.remote_connect_back=1";
            echo "xdebug.remote_autostart=1";
            echo "xdebug.remote_port=${remote_port}";
        } > $inifile;
    fi
    unset extfile remote_port idekey;
fi

exec "$@"
