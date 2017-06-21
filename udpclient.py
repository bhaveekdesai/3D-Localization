# Before using the udp client to communicate with the localization system in Matlab, configure the Matlab default
# python interpreter. (p.s. this requires matlab 2014b or later version). This script uses python 3.5.2, but python 3.4
# or later version should be working.
# in matlab concole, type: "pyversion [pathon_executable_path]"

import socket
import crcmod
from time import sleep
from time import perf_counter
import struct

class BeaconUDP:
    _payload_offset = 5
    _request_header = bytearray(b'\x47\x01\x00\x04\x00\x00\x10')

    def __init__(self, ip, port, beacon_id):
        self.ip = ip
        self.port = port
        self.beacon_id = beacon_id
        self._request_header = beacon_id.to_bytes(1, byteorder='little') + self._request_header

        crc16 = crcmod.predefined.Crc('modbus')
        crc16.update(self._request_header)

        # generate packet CRC
        # seems like correct CRC is not necessary for request packet
        self.request_packet = self._request_header + crc16.digest()

        # create UDP socket
        self.udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        try:
            self.udp_socket.connect((self.ip, self.port))
        except socket.timeout:
            print('Connection timeout, check IP address and port number of the target server')
        except OSError:
            print('\nCannot build connection to the Server/Dashboard')

    def __del__(self):
        if self.udp_socket is not None:
            self.udp_socket.close()

    def close(self):
        self.udp_socket.close()

    def request_position(self):
        self.udp_socket.send(self.request_packet)

        data, address = self.udp_socket.recvfrom(1024)

        # parse the packet, '<' for little endian; 'L' for unsigned long(4);
        # 'h' for short integer(2); 'B' for unsigned char(1); 'x' for pad byte(1); 'H' for unsigned short(2)
        # details of String Format: https://docs.python.org/3.5/library/struct.html
        timestamp, coord_x, coord_y, coord_z, data_crc16 = struct.unpack_from('<LhhhxxxxxxH', data, self._payload_offset)

        return (coord_x,coord_y,coord_z)

def udp_factory(ip, port, beacon_add):
    udp = BeaconUDP(ip, port, beacon_add)
    return udp

##testing code starts from here, uncomment to start test
# host = '127.0.0.1'
# port = 18888
# beacon_add = 26
# udp = udp_factory(host, port, beacon_add)

# rounds = 500
# count = rounds
# interval = 0.1
# duration = 0
# start_time = 0

# while count > 0:
#     count -= 1
#     try:
#         start_time = perf_counter()
#         udp.request_position()
#         duration += (perf_counter() - start_time)
#         sleep(interval)
#     except OSError:
#         print('\nOoops! Shit happened.')

# print('average latency for %d rounds:%f'%(rounds,duration/rounds))

# udp.close()