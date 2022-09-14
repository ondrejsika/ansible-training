#!/bin/sh

terraform -chdir=./terraform output -json ansible-hosts
