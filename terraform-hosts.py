#!/usr/bin/env python3

import os

os.system("terraform -chdir=./terraform output -json ansible-hosts")
