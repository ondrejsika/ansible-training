#!/usr/bin/env python3

import json
import random

print(
    json.dumps(
        {
            "all": {
                "hosts": random.choice(
                    [
                        ["vm0.sikademo.com"],
                        ["vm1.sikademo.com"],
                        ["vm0.sikademo.com", "vm1.sikademo.com"],
                    ]
                )
            }
        }
    )
)
