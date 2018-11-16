# nov/16/2018 23:26:25 by RouterOS 6.38.7
# software id = VRCN-57FC
#
/interface bridge
add name=bridge1
#
# pptp-userman
#
/interface pptp-client
add connect-to=103.227.255.34 disabled=no name=userman password=kJg94352 \
    user=budiwijaya2
/ip firewall layer7-protocol
add name=files regexp="^.*get.+\\.(exe|rar|zip|7z|cab|asf|mov|wmv|mpg|mpeg|mkv\
    |avi|flv|pdf|wav|rm|mp3|mp4|ram|rmvb|dat|daa|iso|nrg|bin|vcd|mp2|3gp|mpe|q\
    t|raw|wma|ogg|doc|deb|tar|bzip|gzip|gzip2|0[0-9][0-9]).*\$"
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
add dns-name=myhotspot.com hotspot-address=172.16.0.1 html-directory=\
    flash/hotspot login-by=cookie,http-chap,http-pap name=hsprof1 use-radius=\
    yes
/ip pool
add name=pool1 ranges=172.16.0.2-172.16.7.254
/ip dhcp-server
add address-pool=pool1 disabled=no interface=bridge1 lease-time=3d10m name=\
    dhcp1
/ip hotspot
add address-pool=pool1 disabled=no interface=bridge1 name=hotspot1 profile=\
    hsprof1
/queue tree
add limit-at=1M max-limit=100M name=Upload parent=ether1 priority=7
/queue type
add kind=pcq name=DL-2M pcq-classifier=dst-address pcq-rate=2M
add kind=pcq name=UP-512k pcq-classifier=src-address pcq-rate=512k
add kind=pcq name=UP-1M pcq-classifier=src-address pcq-rate=1M
/queue tree
add limit-at=100M max-limit=1G name=Hotspot parent=bridge1 priority=7 queue=\
    default
add limit-at=1M max-limit=100M name=4.Browsing packet-mark=pkt-browsing \
    parent=Hotspot priority=7 queue=DL-2M
add limit-at=1M max-limit=100M name=5.Download packet-mark=pkt-files parent=\
    Hotspot priority=7 queue=DL-2M
add limit-at=1M max-limit=100M name=6.Youtube packet-mark=pkt-streaming \
    parent=Hotspot priority=7 queue=DL-2M
add limit-at=8k max-limit=8M name=1.Ping packet-mark=icmp-p parent=Hotspot \
    priority=1
add limit-at=8k max-limit=8M name=2.DNS packet-mark=dns-p parent=Hotspot \
    priority=1
add limit-at=256k max-limit=100M name=3.Games packet-mark=paket-game parent=\
    Hotspot priority=1
add limit-at=1M max-limit=100M name=queue1 packet-mark=pkt-browsing parent=\
    Upload priority=7 queue=UP-512k
add limit-at=1M max-limit=100M name=queue2 packet-mark=pkt-streaming parent=\
    Upload priority=7 queue=UP-512k
add limit-at=1M max-limit=100M name=queue3 packet-mark=pkt-files parent=\
    Upload priority=7 queue=UP-512k
/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
/ip address
add address=172.16.0.1/21 interface=bridge1 network=172.16.0.0
/ip dhcp-client
add default-route-distance=0 dhcp-options=hostname,clientid disabled=no \
    interface=ether1
/ip dhcp-server network
add address=172.16.0.0/21 dns-server=8.8.8.8 gateway=172.16.0.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
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
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall mangle
add action=mark-connection chain=prerouting layer7-protocol=files \
    new-connection-mark=files protocol=tcp src-address=172.16.0.0/16
add action=mark-connection chain=prerouting layer7-protocol=files \
    new-connection-mark=files protocol=udp src-address=172.16.0.0/16
add action=mark-packet chain=prerouting connection-mark=files \
    new-packet-mark=pkt-files passthrough=no
add action=mark-connection chain=prerouting dst-address-list=youtube \
    new-connection-mark=streaming protocol=tcp src-address=172.16.0.0/16
add action=mark-connection chain=prerouting dst-address-list=youtube \
    new-connection-mark=streaming protocol=udp src-address=172.16.0.0/16
add action=mark-packet chain=prerouting connection-mark=streaming \
    new-packet-mark=pkt-streaming passthrough=no
add action=mark-connection chain=prerouting comment=Browsing dst-port=\
    80-88,182,843,443,993,1935,5050,5220-5230,8000-8081,1080 \
    new-connection-mark=browsing protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    21,22,23,8777,8908,9917,22001,21001,20001-20004 new-connection-mark=\
    browsing protocol=tcp
add action=mark-connection chain=prerouting dst-port=80,8080,443 \
    new-connection-mark=browsing protocol=udp
add action=mark-packet chain=prerouting connection-mark=browsing \
    new-packet-mark=pkt-browsing passthrough=no
add action=mark-connection chain=prerouting comment="GAMES PACKET> " \
    dst-port="49100,39190-39200,61000,62000,10009,13008,16666,28012,36567,2792\
    0-27940,7320-7350,18000" new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port="22100,27780,7201-7210,74\
    01-7410,14009,14010,29000,14300-15512,4300,9850-9860,7777" \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port="20050-20200,1230-1260,55\
    00-5520,5540-5580,9810-9860,60170-60180,63000-64000,38101" \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    38110-38130,38600,7800,11000,13000,9220-9230,5050 new-connection-mark=\
    game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    7770-7790,10600-10700,28900-28925,9600,9376-9377,9430-9450,18900-18910 \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    53100-53110,54100,55100,2001-2010,28900-28914,19000 new-connection-mark=\
    game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    9900,2080-2099,7777,9400,9330-9340,6000-6125 new-connection-mark=\
    game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    1800-1900,29001,18000,21900,30000,2000-2110,4000,843,9339 \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    27000-27150,9100-9200,8230-8250,8110-8120 new-connection-mark=game-online \
    protocol=tcp
add action=mark-connection chain=prerouting dst-port=\
    27000-27150,3478-4380,28010-28200,39000 new-connection-mark=game-online \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=30100-30110 \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=9080-9081,7910 \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-address-list=!youtube \
    dst-port=5000-5099,14000,10086 new-connection-mark=game-online protocol=\
    tcp
add action=mark-connection chain=prerouting dst-port=5938,9339 \
    new-connection-mark=game-online protocol=tcp
add action=mark-connection chain=prerouting dst-port=5000-5070 \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=24000-24100,24160,24260 \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port="40000-40010,50000-50100,\
    12020-12080,13000-13080,30000-30030,7800-7850,7020-7050" \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    1800-1900,5050-5060,8000,1500,3005,3101,28960 new-connection-mark=\
    game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    27010-27200,5100,9100-9200,11200-11500 new-connection-mark=game-online \
    protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    16300-16350,10600-10700,8200-8220,9000-9020,4360-4390 \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    14009-14026,14101-14105,15000-15500,42051-42052,8400 new-connection-mark=\
    game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=5355 \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    10001-10025,10170,17000,20000-20010,18000-18010 new-connection-mark=\
    game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=10100-10150 \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=5500-5510,30190 \
    new-connection-mark=game-online protocol=udp
add action=mark-connection chain=prerouting dst-port=\
    10001-10010,17500,39001-39010,39698 new-connection-mark=game-online \
    protocol=tcp
add action=mark-packet chain=prerouting comment="PAKET MARK >GAMES" \
    connection-mark=game-online new-packet-mark=paket-game passthrough=no
add action=mark-connection chain=prerouting comment="ICMP PACKET" \
    new-connection-mark=icmp-c protocol=icmp
add action=mark-packet chain=prerouting connection-mark=icmp-c \
    new-packet-mark=icmp-p
add action=change-dscp chain=prerouting new-dscp=7 packet-mark=icmp-p
add action=mark-connection chain=prerouting comment="DNS PACKET" dst-port=\
    53,5353 new-connection-mark=dns-c protocol=udp
add action=mark-connection chain=prerouting dst-port=53,5353 \
    new-connection-mark=dns-c protocol=tcp
add action=mark-packet chain=prerouting connection-mark=dns-c \
    new-packet-mark=dns-p
add action=change-dscp chain=prerouting new-dscp=7 packet-mark=dns-p
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=172.16.0.0/21
/ip hotspot user
add name=admin password=a
/ip route
add distance=1 gateway=192.168.1.1
/radius
add address=10.100.200.1 secret=rahasia service=hotspot
/system clock
set time-zone-name=Asia/Jakarta
/system ntp client
set enabled=yes primary-ntp=114.141.48.158 secondary-ntp=202.65.114.202
/interface pptp-client remote 0
/
