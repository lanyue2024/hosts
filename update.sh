#!/bin/bash

IP="192.168.1.8"

# for adguardhome
CLIENT="192.168.0.0/16"
IP2="100.100.213.50"
CLIENT2="100.64.0.0/10"

file="hosts.txt"
tmpfile=$(mktemp)
dnsmasq="dnsmasq.conf"
adguardhome="adguardhome.conf"
unbound="unbound.conf"
t=$(date)

if [ -f "$file" ]; then
    echo "# $t" >$dnsmasq
    echo "" >>$dnsmasq

    echo "# $t" >$adguardhome
    echo "" >>$adguardhome

    echo -e "# $t \n" >$unbound
    echo "server: " >>$unbound

    cat $file |tr -d '[:blank:]'|egrep -v '^#|^$' >$tmpfile
    while IFS='' read -r line; do
        echo "address=/${line}/$IP" >>$dnsmasq
        echo "||${line}^\$client=${CLIENT},dnsrewrite=$IP" >>$adguardhome
        echo "||${line}^\$client=${CLIENT2},dnsrewrite=$IP2" >>$adguardhome
        echo "    local-zone: \"${line}\" redirect" >>$unbound
        echo -e "    local-data: \"${line} 30 IN A $IP\" \n" >>$unbound
    done < "$tmpfile"
fi

rm $tmpfile

