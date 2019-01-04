# dec/20/2018 17:17:14 by RouterOS 6.42.10
# software id = JLH0-NVLM
#
# model = RouterBOARD D52G-5HacD2HnD-TC
# serial number = 8A2A0876F364
/ip firewall layer7-protocol
add name=files regexp="^.*get.+\\.(exe|rar|zip|7z|cab|asf|mov|wmv|mpg|mpeg|mkv\
    |avi|flv|pdf|wav|rm|mp3|mp4|ram|rmvb|dat|daa|iso|nrg|bin|vcd|mp2|3gp|mpe|q\
    t|raw|wma|ogg|doc|deb|tar|bzip|gzip|gzip2|0[0-9][0-9]).*\$"
/ip firewall address-list
add address=192.168.0.0/16 list=lokal-private
add address=172.16.0.0/12 list=lokal-private
add address=10.0.0.0/8 list=lokal-private
add address=74.125.0.0/16 list=youtube
add address=118.96.0.0/14 list=youtube
add address=172.217.0.0/16 list=youtube
add address=173.192.0.0/12 list=youtube
add address=209.80.0.0/12 list=youtube
add address=216.224.0.0/12 list=youtube
add address=103.227.255.34 list=lokal-private
add address=172.16.255.255 list=router-mk
add address=192.168.1.2 list=router-mk
add address=103.227.255.39 list=lokal-private
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall mangle
add action=fasttrack-connection chain=forward comment="Game Online" \
    connection-state=established,related dst-port="49100,39190-39200,61000,620\
    00,10009,13008,16666,28012,36567,27920-27940,7320-7350,18000" protocol=\
    tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port="22100,27780,7201-7210,7401-7410,14009,14010,\
    29000,14300-15512,4300,9850-9860,7777" protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port="20050-20200,1230-1260,5500-5520,5540-5580,98\
    10-9860,60170-60180,63000-64000,38101" protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    38110-38130,38600,7800,11000,13000,9220-9230,5050 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    7770-7790,10600-10700,28900-28925,9600,9376-9377,9430-9450,18900-18910 \
    protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    53100-53110,54100,55100,2001-2010,28900-28914,19000 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=9900,2080-2099,7777,9400,9330-9340,6000-6125 \
    protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    1800-1900,29001,18000,21900,30000,2000-2110,4000,843,9339 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=27000-27150,9100-9200,8230-8250,8110-8120 \
    protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=27000-27150,3478-4380,28010-28200,39000 \
    protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=30100-30110 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=9080-9081,7910 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-address-list=!youtube dst-port=\
    5000-5099,14000,10086 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=5938,9339 protocol=tcp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=5000-5070 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=24000-24100,24160,24260 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port="40000-40010,50000-50100,12020-12080,13000-13\
    080,30000-30030,7800-7850,7020-7050" protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    1800-1900,5050-5060,8000,1500,3005,3101,28960 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=27010-27200,5100,9100-9200,11200-11500 \
    protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    16300-16350,10600-10700,8200-8220,9000-9020,4360-4390 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    14009-14026,14101-14105,15000-15500,42051-42052,8400 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=5355 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=\
    10001-10025,10170,17000,20000-20010,18000-18010 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=10100-10150 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=5500-5510,30190 protocol=udp
add action=fasttrack-connection chain=forward connection-state=\
    established,related dst-port=10001-10010,17500,39001-39010,39698 \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=53,5353 \
    new-connection-mark=dns-c passthrough=yes protocol=tcp src-address=\
    192.168.150.0/23
add action=mark-connection chain=prerouting dst-port=53,5353 \
    new-connection-mark=dns-c passthrough=yes protocol=udp src-address=\
    192.168.150.0/23
add action=mark-packet chain=prerouting connection-mark=dns-c \
    new-packet-mark=dns-p passthrough=no
add action=mark-connection chain=prerouting new-connection-mark=icmp-c \
    passthrough=yes protocol=icmp src-address=192.168.150.0/23
add action=mark-packet chain=prerouting connection-mark=icmp-c \
    new-packet-mark=latency passthrough=no
add action=mark-connection chain=prerouting connection-rate=0-100k dst-port=\
    !53,5353,21,22,23,80,443,8080,1080,182,282,5222,5228 new-connection-mark=\
    game_v1 passthrough=yes protocol=tcp src-address=192.168.150.0/23
add action=mark-connection chain=prerouting connection-rate=0-100k dst-port=\
    !53,5353,80,8080,443 new-connection-mark=game_v1 passthrough=yes \
    protocol=udp src-address=192.168.150.0/23
add action=mark-packet chain=prerouting connection-mark=game_v1 \
    new-packet-mark=game-v1 passthrough=no
add action=mark-connection chain=prerouting connection-rate=100001-200k \
    dst-port=!53,5353,21,22,23,80,443,8080,1080,182,282,5222,5228 \
    new-connection-mark=game_v2 passthrough=yes protocol=tcp src-address=\
    192.168.150.0/23
add action=mark-connection chain=prerouting connection-rate=100001-200k \
    dst-port=!53,5353,80,8080,443 new-connection-mark=game_v2 passthrough=yes \
    protocol=udp src-address=192.168.150.0/23
add action=mark-packet chain=prerouting connection-mark=game_v2 \
    new-packet-mark=game-v2 passthrough=no
add action=mark-connection chain=prerouting connection-rate=200001-500k \
    dst-port=!53,5353,21,22,23,80,443,8080,1080,182,282,5222,5228 \
    new-connection-mark=game_v3 passthrough=yes protocol=tcp src-address=\
    192.168.150.0/23
add action=mark-connection chain=prerouting connection-rate=200001-500k \
    dst-port=!53,5353,80,8080,443 new-connection-mark=game_v3 passthrough=yes \
    protocol=udp src-address=192.168.150.0/23
add action=mark-packet chain=prerouting connection-mark=game_v3 \
    new-packet-mark=game-v3 passthrough=no
add action=mark-connection chain=prerouting dst-port=\
    21,22,23,80,443,8080,1080,182,282 new-connection-mark=browsing \
    passthrough=yes protocol=tcp src-address=192.168.150.0/23
add action=mark-connection chain=prerouting dst-port=80,8080,443 \
    new-connection-mark=browsing passthrough=yes protocol=udp src-address=\
    192.168.150.0/23
add action=mark-connection chain=prerouting connection-rate=500001-4294967295 \
    dst-address-list=!lokal-private new-connection-mark=browsing passthrough=\
    yes protocol=tcp src-address=192.168.150.0/23
add action=mark-connection chain=prerouting connection-rate=500001-4294967295 \
    dst-address-list=!lokal-private new-connection-mark=browsing passthrough=\
    yes protocol=udp src-address=192.168.150.0/23
add action=mark-packet chain=prerouting connection-mark=browsing \
    new-packet-mark=pkt-browsing passthrough=no
