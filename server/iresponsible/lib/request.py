import bitstring
import struct
from iresponsible.lib import util

class Request(util.ComparableObject):
    def __init__(self, addr, data):
        self.addr = addr
        self.data = data

        bits = []

        print "==="

        x, y = struct.unpack(">II", data)
        want_bits_before = []
        have_bits_before = []
        for b in util.bits(x):
            bits.append(0 if b == 0 else 1)
            want_bits_before.append(0 if b == 0 else 1)
        for b in util.bits(y):
            bits.append(0 if b == 0 else 1)
            have_bits_before.append(0 if b == 0 else 1)

        want_bits = list(reversed([bits[i] for i in xrange(64) if i % 2 == 0]))
        have_bits = list(reversed([bits[i] for i in xrange(64) if i % 2 == 1]))

        want_bitstring = bitstring.BitArray(want_bits)
        have_bitstring = bitstring.BitArray(have_bits)

        self.want = struct.unpack(">I", want_bitstring.bytes)[0]
        self.have = struct.unpack(">I", have_bitstring.bytes)[0]

        print "data", data.encode("hex")
        print "bits", bits
        print "want_bits_before", want_bits_before

        print "want_bits", want_bits
        print "want_bitstring", want_bitstring
