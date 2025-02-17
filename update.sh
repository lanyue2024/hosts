#!/bin/bash

IP="100.85.41.5"
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
        echo "||${line}^\$dnsrewrite=$IP" >>$adguardhome
        echo "    local-zone: \"${line}\" redirect" >>$unbound
        echo -e "    local-data: \"${line} 30 IN A $IP\" \n" >>$unbound
    done < "$tmpfile"
fi

rm $tmpfile

