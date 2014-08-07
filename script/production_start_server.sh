#!/bin/bash

set -x

thin stop
thin -d -p 3200 -s3 -e production start
