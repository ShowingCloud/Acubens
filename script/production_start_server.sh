#!/bin/bash

set -x

[ -f tmp/pids/server_1.pid ] && kill $(cat tmp/pids/server_1.pid)
[ -f tmp/pids/server_2.pid ] && kill $(cat tmp/pids/server_2.pid)
[ -f tmp/pids/server_3.pid ] && kill $(cat tmp/pids/server_3.pid)

rails s -d -p 3200 -e production -P `pwd`/tmp/pids/server_1.pid
rails s -d -p 3201 -e production -P `pwd`/tmp/pids/server_2.pid
rails s -d -p 3202 -e production -P `pwd`/tmp/pids/server_3.pid
