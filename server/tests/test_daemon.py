import unittest2
import struct

from iresponsible.lib.request import Request

class TestDaemon(unittest2.TestCase):
    def test_request_parse(self):
        data = struct.pack("hhhh", 0, 0, 0, 0)
        req = Request(None, data)
        self.assertEqual(0, req.want)
        self.assertEqual(0, req.have)

        data = struct.pack("hhhh", 0, 0, 0, 1)
        req = Request(None, data)
        self.assertEqual(1, req.want)
        self.assertEqual(0, req.have)

        data = struct.pack("hhhh", 0, 0, 0, 2)
        req = Request(None, data)
        self.assertEqual(0, req.want)
        self.assertEqual(1, req.have)
