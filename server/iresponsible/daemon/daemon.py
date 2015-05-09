import multiprocessing.pool
import socket
import time

from iresponsible.lib import util

class IResponsibleDaemon(object):
    def __init__(self, hostname, port):
        self.pool = multiprocessing.pool.ThreadPool(1)
        self.port = port
        self.hostname = hostname
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def daemon_loop(self):
        while True:
            try:
                request = self.pop_request()
                print request

                time.sleep(1)
            except Exception as ex:
                print "Exception: {}".format(ex)

    def pop_request(self):
        data, addr = self.sock.recvfrom(1024)
        return Request(addr, data)


    def start(self):
        self.sock.bind((self.hostname, self.port))
        self.pool.apply_async(self.daemon_loop)

        try:
            while True:
                time.sleep(99999)
        except (KeyboardInterrupt, SystemExit) as ex:
           self.terminate_workers()
