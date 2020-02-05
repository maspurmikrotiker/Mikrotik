# jan/12/2020 21:59:25 by RouterOS 6.44.6
# software id = FS9Y-VKTB
#
# model = 450G
# serial number = 72520858DF93
/ip firewall mangle
add action=accept chain=prerouting dst-address-list=private-lokal \
    src-address-list=private-lokal
add action=mark-connection chain=prerouting comment=ping dst-address-list=\
    !private-lokal new-connection-mark=icmp-c passthrough=yes protocol=icmp \
    src-address-list=private-lokal
add action=mark-packet chain=prerouting connection-mark=icmp-c \
    new-packet-mark=latency passthrough=yes
add action=change-dscp chain=prerouting new-dscp=from-priority packet-mark=\
    latency passthrough=yes
add action=mark-connection chain=input dst-address-list=!private-lokal \
    new-connection-mark=icmp-c passthrough=yes protocol=icmp \
    src-address-list=private-lokal
add action=mark-packet chain=input connection-mark=icmp-c new-packet-mark=\
    latency passthrough=yes
add action=change-dscp chain=input new-dscp=from-priority packet-mark=latency \
    passthrough=yes
add action=mark-connection chain=output dst-address-list=!private-lokal \
    new-connection-mark=icmp-c passthrough=yes protocol=icmp \
    src-address-list=private-lokal
add action=mark-packet chain=output connection-mark=icmp-c new-packet-mark=\
    latency passthrough=yes
add action=change-dscp chain=output new-dscp=from-priority packet-mark=\
    latency passthrough=yes
add action=mark-connection chain=output comment=DNS dst-port=53,5353 \
    new-connection-mark=dns-c passthrough=yes protocol=udp
add action=mark-packet chain=output connection-mark=dns-c new-packet-mark=\
    dns-p passthrough=yes
add action=change-dscp chain=output new-dscp=from-priority packet-mark=dns-p \
    passthrough=yes
add action=mark-connection chain=input dst-port=53,5353 new-connection-mark=\
    dns-c passthrough=yes protocol=udp
add action=mark-packet chain=input connection-mark=dns-c new-packet-mark=\
    dns-p passthrough=yes
add action=change-dscp chain=input new-dscp=from-priority packet-mark=dns-p \
    passthrough=yes
add action=mark-connection chain=prerouting dst-port=53,5353 \
    new-connection-mark=dns-c passthrough=yes protocol=udp
add action=mark-packet chain=prerouting connection-mark=dns-c \
    new-packet-mark=dns-p passthrough=no
add action=mark-connection chain=prerouting comment=games connection-rate=\
    1-400001 dst-address-list=!private-lokal dst-port=\
    !80,443,8080,1080,182,282,5222,5228,53,5353,21,22,23 new-connection-mark=\
    games-online passthrough=yes protocol=tcp src-address-list=private-lokal
add action=mark-connection chain=prerouting connection-rate=1-400001 \
    dst-address-list=!private-lokal dst-port=!80,8080,443,53,5353 \
    new-connection-mark=games-online passthrough=yes protocol=udp \
    src-address-list=private-lokal
add action=mark-packet chain=prerouting connection-mark=games-online \
    new-packet-mark=games passthrough=no
add action=mark-connection chain=prerouting comment=browsing \
    dst-address-list=!private-lokal dst-port=8080,1080,182,282,5222,5228 \
    new-connection-mark=browsing passthrough=yes protocol=tcp \
    src-address-list=all-client
add action=mark-connection chain=prerouting dst-address-list=!private-lokal \
    dst-port=21-23,80,81,88,993,5050,843,443,182,8777,1935 \
    new-connection-mark=browsing passthrough=yes protocol=tcp \
    src-address-list=all-client
add action=mark-connection chain=prerouting dst-address-list=!private-lokal \
    dst-port=80,8080,443 new-connection-mark=browsing passthrough=yes \
    protocol=udp src-address-list=all-client
add action=mark-connection chain=prerouting connection-rate=400002-4294967295 \
    dst-address-list=!private-lokal new-connection-mark=browsing passthrough=\
    yes protocol=tcp src-address-list=all-client
add action=mark-connection chain=prerouting connection-rate=400002-4294967295 \
    dst-address-list=!private-lokal new-connection-mark=browsing passthrough=\
    yes protocol=udp src-address-list=all-client
add action=mark-packet chain=prerouting connection-mark=browsing \
    new-packet-mark=pkt-browsing passthrough=no
add action=mark-connection chain=prerouting comment="local to local" \
    dst-address-list=private-lokal new-connection-mark=localnet passthrough=\
    yes src-address-list=private-lokal
add action=mark-packet chain=prerouting connection-mark=localnet \
    new-packet-mark=pkt-local passthrough=no
