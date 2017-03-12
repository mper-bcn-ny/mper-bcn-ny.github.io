# HOWTO: wifionice.de on Ubuntu 16.04

My Ubuntu 16.04 did not work with @DB_Bahn's Wifi network out of the box. See below to find out what I did.

You can execute the included script `free-wifionice.sh` as well - it does the same, automatically. Please be prepared
to enter your password, because part of it has to be run as root.

Here's the details:


**Step 1** Connect to the WLAN `wifionice`. 

**Step 2**. Fire up your browser and open http://www.wifionice.de - at this point, I got an "unable to connect" message.

**Step 3**.. Open up a terminal (Ctrl-Alt-T on Ubuntu) and find out the IP address of www.wifionice.de

```sh
$ host www.wifionice.de
wifionice.de has address 172.18.10.10
```

**Step 4**.. Confirm that the IP address (in my case it was `172.18.10.10`, see above) is not reachable
```sh
$ ping -c 1 172.19.10.10
PING 172.19.10.10 (172.19.10.10) 56(84) bytes of data.
From 172.19.0.1 icmp_seq=1 Destination Host Unreachable

--- 172.19.10.10 ping statistics ---
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
```

**Step 5**.. Look at your routing table and try to find blockers. Mine looked like this:
```sh
$ route 
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.16.0.1      0.0.0.0         UG    600    0        0 wlan0
link-local      *               255.255.0.0     U     1000   0        0 br-42b83c0b858b
172.18.0.0      *               255.255.0.0     U     0      0        0 br-eea55c5060c3
```
The last line says: route every IP starting with `172.18` through bridge `br-eea55c5060c3`. 
This is what blocked my connection to www.wifionice.de, whose IP address is `172.18.10.10`,
as we found out above.

**Step 6**.. Delete the offending bridge  `br-eea55c5060c3`. You need root capabilities to do this, 
the sudo command might prompt you for your password. 
```sh
> sudo ifconfig br-eea55c5060c3 down; sudo brctl delbr br-eea55c5060c3
```

**Step 7**.. Confirm everything is working. Then point your browser to http://172.18.10.10 (the IP address from step 3).
```sh
> ping -c 1 172.18.10.10
PING 172.18.10.10 (172.18.10.10) 56(84) bytes of data.
64 bytes from 172.18.10.10: icmp_seq=1 ttl=63 time=2.26 ms

--- 172.18.10.10 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 2.264/2.264/2.264/0.000 ms
```


