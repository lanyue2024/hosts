# hosts
搭配dnsmasq/adguardhome和sniproxy使用。

## dnsmasq
修改<dnsmasq.conf>中的IP为sniproxy地址。
```
address=/sniproxy.local/IP
```

## adguardhome
在后台<过滤器><DNS重写>加入以下两条指向sniproxy。
```
sniproxy.local
raw.githubusercontent.com
```

在<过滤器><DNS黑名单>添加自定义列表，URL填：

https://raw.githubusercontent.com/lanyue2024/hosts/main/adguardhome.txt
