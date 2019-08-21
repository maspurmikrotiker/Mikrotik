# aug/21/2019 11:13:42 by RouterOS 6.44.5
# software id = 0WCB-Z5AU
#
# model = RB750Gr3
# serial number = 8AFF09CB8752
/ip firewall address-list
add address=172.16.0.0/12 list=client
add address=10.0.0.0/8 list=lokal-private
add address=192.168.0.0/16 list=lokal-private
add address=172.16.0.0/12 list=lokal-private
/ip firewall connection tracking
set generic-timeout=5m icmp-timeout=5s tcp-close-timeout=5s \
    tcp-close-wait-timeout=5s tcp-fin-wait-timeout=5s tcp-last-ack-timeout=5s \
    tcp-max-retrans-timeout=3m tcp-syn-received-timeout=3s \
    tcp-syn-sent-timeout=3s tcp-time-wait-timeout=5s tcp-unacked-timeout=3m \
    udp-stream-timeout=1m
/ip firewall filter
add action=drop chain=forward dst-port=445 protocol=tcp
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall mangle
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
add action=mark-connection chain=forward comment=ping dst-address-list=\
    !lokal-private new-connection-mark=icmp-c passthrough=yes protocol=icmp \
    src-address-list=client
add action=mark-packet chain=forward connection-mark=icmp-c new-packet-mark=\
    latency passthrough=yes
add action=change-dscp chain=forward new-dscp=from-priority packet-mark=\
    latency passthrough=yes
add action=mark-connection chain=forward comment=games connection-rate=1-500k \
    dst-address-list=!lokal-private dst-port=\
    !80,443,8080,1080,182,282,5222,5228,53,5353,21,22,23 new-connection-mark=\
    games-online passthrough=yes protocol=tcp src-address-list=client
add action=mark-connection chain=forward connection-rate=1-500k \
    dst-address-list=!lokal-private dst-port=!80,8080,443,53,5353 \
    new-connection-mark=games-online passthrough=yes protocol=udp \
    src-address-list=client
add action=mark-packet chain=forward connection-mark=games-online \
    new-packet-mark=games passthrough=no
add action=mark-connection chain=forward comment=browsing dst-address-list=\
    !lokal-private dst-port=8080,1080,182,282,5222,5228 new-connection-mark=\
    browsing passthrough=yes protocol=tcp src-address-list=client
add action=mark-connection chain=forward dst-address-list=!lokal-private \
    dst-port=21-23,80,81,88,993,5050,843,443,182,8777,1935 \
    new-connection-mark=browsing passthrough=yes protocol=tcp \
    src-address-list=client
add action=mark-connection chain=forward dst-address-list=!lokal-private \
    dst-port=80,8080,443 new-connection-mark=browsing passthrough=yes \
    protocol=udp src-address-list=client
add action=mark-connection chain=forward connection-rate=300001-4294967295 \
    dst-address-list=!lokal-private new-connection-mark=browsing passthrough=\
    yes protocol=tcp src-address-list=client
add action=mark-connection chain=forward connection-rate=300001-4294967295 \
    dst-address-list=!lokal-private new-connection-mark=browsing passthrough=\
    yes protocol=udp src-address-list=client
add action=mark-packet chain=forward connection-mark=browsing \
    new-packet-mark=pkt-browsing passthrough=no
add action=mark-connection chain=forward comment="local to local" \
    dst-address-list=lokal-private new-connection-mark=ether3net passthrough=\
    yes src-address-list=lokal-private
add action=mark-packet chain=forward connection-mark=ether3net \
    new-packet-mark=pkt-local passthrough=no
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=172.16.16.0/23
