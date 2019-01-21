# jan/04/2019 12:55:15 by RouterOS 6.42.9
# vpn maspur 0822-3348-3221
#
/interface sstp-client
add comment=vpn-maspur connect-to=128.199.140.26 disabled=no name=vpn-maspur \
    user=HHH password=yyy profile=default-encryption

/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/

:if ([:len [/file find name=nice.rsc]] > 0) do={/file remove nice.rsc }; /tool fetch address=ixp.mikrotik.co.id src-path=/download/nice.rsc mode=http;/import nice.rsc;

/ip firewall mangle
add action=mark-routing chain=prerouting comment=vpn-maspur connection-rate=\
    0-256k dst-address-list=!nice dst-port=21-25,80,443,8080,8291,8728,8727 \
    new-routing-mark=vpn-maspur passthrough=yes protocol=tcp \
    src-address-list=local
add action=mark-routing chain=prerouting comment=vpn-maspur connection-rate=\
    0-256k dst-address-list=!nice dst-port=21-25,80,443,8080,8291,8728,8727 \
    new-routing-mark=vpn-maspur passthrough=yes protocol=udp \
    src-address-list=local
/ip firewall nat
add action=masquerade chain=srcnat comment=vpn-maspur out-interface=\
    vpn-maspur

/ip route
add comment=vpn-maspur distance=1 gateway=vpn-maspur routing-mark=vpn-maspur
add comment=vpn-maspur distance=1 dst-address=8.8.4.4/32 gateway=vpn-maspur
add comment=vpn-maspur distance=1 dst-address=8.8.8.8/32 gateway=vpn-maspur

/system ntp client
set enabled=yes primary-ntp=203.160.128.66 secondary-ntp=202.162.32.12

/system scheduler
add comment=vpn-maspur interval=1w name=000-nice on-event=":if ([:len [/file f\
    ind name=nice.rsc]] > 0) do={/file remove nice.rsc }; /tool fetch address=\
    ixp.mikrotik.co.id src-path=/download/nice.rsc mode=http;/import nice.rsc;\
    " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=jan/04/2019 start-time=04:00:00
/
