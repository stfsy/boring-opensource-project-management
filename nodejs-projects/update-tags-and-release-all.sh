#!/bin/bash

set -ex

./01_checkout.sh
./02_update-and-tag.sh
./03_publish.sh
./04_clean.sh