#!/bin/bash
set -e
set -x

service tirex-master start
service tirex-backend-manager start
/usr/sbin/apache2ctl -DFOREGROUND

