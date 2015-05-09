class IResponsibleClient(object):
    def __init__(self, hostname, port):
        self.hostname = hostname
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) 

    def inquisition(self, want_cost, have_cost):
        self.sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
