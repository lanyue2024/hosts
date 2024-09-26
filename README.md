# hosts
被封网站集合，搭配dnsmasq/adguardhome和sniproxy使用。

sniproxy：https://github.com/lanyue2024/h2-tunnel


## dnsmasq
修改<dnsmasq.conf>中这行的IP为sniproxy的IP地址。
```
address=/sniproxy.local/IP
```

## adguardhome
在后台<过滤器><DNS重写>加入以下两条指向sniproxy的IP。
```
sniproxy.local
raw.githubusercontent.com
```

在<过滤器><DNS黑名单>添加自定义列表，URL填：

https://raw.githubusercontent.com/lanyue2024/hosts/main/adguardhome.txt
