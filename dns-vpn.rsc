/interface sstp-client
add connect-to=omnitik.com disabled=no name=yyyyyy password=xxxxx profile=default-encryption user=dns

/ip firewall nat add chain=srcnat out-interface=dns-vpn action=masquerade 

/ip route
add check-gateway=ping distance=1 dst-address=8.8.8.8/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=8.8.4.4/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=208.67.222.222/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=208.67.220.220/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=208.67.222.123/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=208.67.220.123/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=176.103.130.134/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=176.103.130.132/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=1.1.1.1/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=1.0.0.1/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=180.131.144.144/32 gateway=dns-vpn
add check-gateway=ping distance=1 dst-address=180.131.145.145/32 gateway=dns-vpn
/tool netwatch
add host=10.0.32.1

/ip dns
set servers=8.8.8.8,8.8.4.4
