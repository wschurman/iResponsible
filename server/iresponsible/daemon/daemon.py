import multiprocessing.pool
import json
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
                data, addr = self.sock.recvfrom(1024)
                try:
                    request = Request(addr, data)
                    want = request.want
                    have = request.have
                    if want > have:
                        response = NoResponse().bytes()
                    else:
                        response = YesResponse().bytes()
                except Exception:
                    blob = json.loads(data)
                    want = blob["want"]
                    have = blob["have"]
                    if want > have:
                        d = {"answer": "no"}
                    else:
                        d = {"answer": "yes"}
                    d["client_request_id"] = blob["client_request_id"]
                    response = json.dumps(d)

                print "want", want, "have", have, "response", response
                sent = self.sock.sendto(response, addr)
                print "sent?", sent, addr
            except Exception as ex:
                print "Exception: {} {} {}".format(ex, addr, repr(data))
                sent = self.sock.sendto("fail", addr)
                print "sent?", sent, addr

            time.sleep(1)

    def pop_request(self):
        return Request(addr, data)

    def start(self):
        self.sock.bind((self.hostname, self.port))
        self.pool.apply_async(self.daemon_loop)

        try:
            while True:
                time.sleep(99999)
        except (KeyboardInterrupt, SystemExit) as ex:
           # self.terminate_workers()
           pass
