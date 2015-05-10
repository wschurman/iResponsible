import bitstring

class YesResponse(object):
    def __init__(self):
        self.data = bitstring.BitArray("")
        pass

class NoResponse(object):
    def __init__(self):
        pass
