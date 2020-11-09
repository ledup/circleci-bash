#!/bin/bash

service_user="circleci"
service_group=$(id -g -n ${service_user})

old_uid=$(id -u ${service_user})
old_gid=$(id -g ${service_user})

if [ -n "${_UID}" ]; then
    su -c "usermod -u ${_UID} ${service_user}"

    if [ -n "${_GID}" ]; then
        su -c "groupmod -g ${_GID} ${service_group}"
    fi

    su -c "find / -path /proc -prune -o -group ${old_gid} -exec chgrp -h ${service_group} {} \;"
    su -c "find / -path /proc -prune -o -user ${old_uid} -exec chown -h ${service_user} {} \;"
fi

export HOME="/home/circleci"
/usr/local/bin/gosu circleci "$@"
