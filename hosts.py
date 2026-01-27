#!/usr/bin/env python3

import json
import random

print(
    json.dumps(
        {
            "all": {
                "hosts": random.choice(
                    [
                        ["lab0-vm0.sikademo.com"],
                        ["lab0-vm1.sikademo.com"],
                        ["lab0-vm0.sikademo.com", "lab0-vm1.sikademo.com"],
                    ]
                )
            }
        }
    )
)
