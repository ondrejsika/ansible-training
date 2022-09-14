
#!/usr/bin/python3


class FilterModule(object):
    def filters(self):
        return {"ufw_config_expansion": self.ufw_config_expansion}

    def ufw_config_expansion(self, data):
        out = []
        for proto, d1 in data:
            for port, ifce in d1:
                out.append([proto, port, ifce])
        return out
