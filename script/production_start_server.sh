#!/bin/bash

set -x

thin stop
thin -d -p 3200 -e production start
thin -d -p 3201 -e production start
thin -d -p 3202 -e production start
