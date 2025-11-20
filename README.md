# Requirements

Network (created in "Your node" -> System -> Network, don't forget to make it 
autostart):
- 192.168.1.x <-- home network (connected to physical port and existing gateway)
- 10.10.10.x <-- homelab network (only CIDR 10.10.10.1)

# Nodes setup

## 1. Router VM

Create VM that is connected to both networks (Proxmox -> Router vm -> Hardware
-> Network Device -> add both of them). In cloud-init set static ip in homelab
network to be 10.10.10.1 (as a gateway) and in home network dhcp can be used. \

Next steps:

### Allow IP Forwarding

```sh
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w net.ipv4.ip_forward=1
```

### NAT Masquerading

```sh
sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.10.10.0/24 -j MASQUERADE
```

### Persist IP Tables

```sh
sudo apt install -y iptables-persistent
sudo netfilter-persistent save
```

## 2. Cluster Nodes

I like to make some kind of base template that I can easly clone later, so
I use Ubuntu Cloud Image with 4 vCPUs and 6 GBs RAM (I don't have professional
equipment - my old Dell laptop :D). Connect it to homelab network and in cloud-init
set Gateway to be router vm ip in homelab network (10.10.10.1). Passing SSH public
keys won't hurt and it will increase seciurity (**use public key from router vm
because it will also work as our access point to the cluster!**). User name isn't
importat, but we have to remember to make it the same on all nodes. So that's why I
use cloud-init for convinience.

If everything is setup correctly, it should be possible to ssh into router VM and 
from it, ssh into cluster nodes. Why this architecure? Because we will use router
vm to run our ansible code, to automaticly configure whole kubernetes cluster.
