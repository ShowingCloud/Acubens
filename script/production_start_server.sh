#!/bin/bash

set -x

thin stop
thin -d -p 3250 -e production --tag "Gelnic Production" start
