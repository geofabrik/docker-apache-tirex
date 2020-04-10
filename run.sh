#!/bin/bash
set -ex

trap 'stop' SIGTERM

run=1
stop() {
  sudo -u tirex /etc/init.d/tirex-backend-manager stop
  sudo -u tirex /etc/init.d/tirex-master stop
  apache2ctl stop
  run=0
}

sudo -u tirex /etc/init.d/tirex-master start
sudo -u tirex /etc/init.d/tirex-backend-manager start
apache2ctl start

until [ $run -lt 1 ]
do
  sleep 2
done

# give apache time to cleanup and exit
sleep 4
