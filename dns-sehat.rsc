/ip fi add add list=LOCAL address=127.0.0.0/8 comment=DNS-vpn
/ip fi add add list=LOCAL address=192.168.0.0/16 comment=DNS-vpn
/ip fi add add list=LOCAL address=172.16.0.0/12 comment=DNS-vpn
/ip fi add add list=LOCAL address=10.0.0.0/8 comment=DNS-vpn
/int pptp-client add name=DNS-vpn connect-to=103.80.80.112 user=DNS-vpn password=!QAZ2wsx#EDC4rfv max-mtu=1492 max-mru=1492 add-default-route=no disabled=no comment=DNS-vpn
/ip fi fi add chain=input src-address-list=!LOCAL protocol=udp dst-port=53 action=drop comment=DNS-vpn
/ip fi fi move [find comment=DNS-vpn] 0
/ip fi na add chain=dstnat src-address-list=LOCAL protocol=udp dst-port=53 action=redirect to-ports=53 comment=DNS-vpn
/ip fi na add chain=srcnat action=masquerade out-interface=DNS-vpn comment=DNS-vpn
/ip fi na move [find comment=DNS-vpn] 0
/ip ro add gateway=172.31.255.254 routing-mark=DNS-vpn comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=103.80.80.243 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=103.80.80.244 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=103.80.80.248 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=103.80.80.249 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=208.67.220.220 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=208.67.222.222 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=8.8.8.8 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=8.8.4.4 comment=DNS-vpn
/ip rou rule add action=lookup table=DNS-vpn dst-address=151.101.10.219 comment=DNS-vpn
/ip dns set servers=103.80.80.248,103.80.80.249 allow-remote-requests=yes


########################################################################################
########################################################################################

# BAGI YANG INGIN MEMBUANG RULE DIATAS BERIKUT PERINTAHNYA

/ip fi add rem [find comment=DNS-vpn]
/int pptp-client rem [find comment=DNS-vpn]
/ip fi fi rem [find comment=DNS-vpn]
/ip fi na rem [find comment=DNS-vpn]
/ip ro rem [find comment=DNS-vpn]
/ip rou rule rem [find comment=DNS-vpn]
/ip dns set servers=8.8.8.8,8.8.4.4 allow-remote-requests=yes
