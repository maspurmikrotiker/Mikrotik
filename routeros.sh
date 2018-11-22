apt-get update && \
apt install -y gunzip && \
apt install -y qemu-utils pv && \
wget http://download2.mikrotik.com/routeros/6.42.9/chr-6.42.9.img.zip -O chr.img.zip && \
sleep 1 && \
gunzip -c chr.img.zip > chr.img  && \
qemu-img convert chr.img -O qcow2 chr.qcow2 && \
qemu-img resize chr.qcow2 `fdisk /dev/vda -l | head -n 1 | cut -d',' -f 2 | cut -d' ' -f 2` && \
modprobe nbd && \
qemu-nbd -c /dev/nbd0 chr.qcow2 && \
echo "Tunggulah persiapan qemu-nbd" && \
sleep 5 && \
partprobe /dev/nbd0 && \
mount /dev/nbd0p2 /mnt && \
ADDRESS=`ip addr show eth0 | grep global | cut -d' ' -f 6 | head -n 1` && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip dns set servers=8.8.8.8,8.8.4.4
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
/user add name=YOURNAME group=full password=****
/user remove admin
/
 " > /mnt/rw/autorun.scr && \
umount /mnt && \
echo "Sedang menyiapkan partisi baru, periksa dulu dgn fdisk sebelum eksekusi" && \
echo "ini akan menghapus partisi 2 di nbd0 dan menyatukannya kedalam pertisi baru yg lebih besar" && \
echo -e 'd\n2\nn\np\n2\n65537\n\nw\n' | fdisk /dev/nbd0 && \
e2fsck -f -y /dev/nbd0p2 || true && \
resize2fs /dev/nbd0p2 && \
sleep 1 && \
echo "Proses kompresi image gzip" && \
mount -t tmpfs tmpfs /mnt && \
pv /dev/nbd0 | gzip > /mnt/chr-extended.gz && \
sleep 1 && \
killall qemu-nbd && \
sleep 1 && \
echo u > /proc/sysrq-trigger && \
echo "Warming up sleep" && \
sleep 1 && \
echo "Proses penggantian Linux ke MikroTik ROuterOS" && \
zcat /mnt/chr-extended.gz | pv > /dev/vda && \
echo "Tunggu 5 detik" && \
sleep 5 || true && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Ok, reboot" && \
echo b > /proc/sysrq-trigger
 
 
