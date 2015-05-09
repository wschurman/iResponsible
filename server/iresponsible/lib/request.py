from iresponsible.lib import util
class Request(util.ComparableObject):
    def __init__(self, addr, data):
        self.addr = addr
        self.data = data
        self.want = 0
        self.have = 0
