#!/bin/bash

set -ex

FOLDER='check_update_dependencies_and_release'

./"$FOLDER"/01_checkout.sh
./"$FOLDER"/02_update-and-tag.sh
./"$FOLDER"/03_publish.sh
./"$FOLDER"/04_clean.sh