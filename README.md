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

### DHCP server

```sh
sudo apt update
sudo apt install isc-dhcp-server
```

Config allowed dhcp ranges in this file: "/etc/dhcp/dhcpd.conf".
Condig should look like this (range is variable):

```
subnet 10.10.10.0 netmask 255.255.255.0 {
    range 10.10.10.x 10.10.10.y;
    option routers 10.10.10.1;
    option domain-name-servers 1.1.1.1, 8.8.8.8;
    
    # Example Static IP Reservations (set this after nodes are created)
    host homelab-node-1 {
        hardware ethernet aa:bb:cc:dd:ee:ff;
        fixed-address 10.10.10.50;               
    }

    host homelab-node-2 {
        hardware ethernet 11:22:33:44:55:66;
        fixed-address 10.10.10.51;
    }
}
```

Set interface to "eth1" in "sudo nano /etc/default/isc-dhcp-server".

And now start DHCP server:

```sh
sudo systemctl enable isc-dhcp-server
sudo systemctl start isc-dhcp-server
```

## 1,5. Optional Step - Tailscale access to subnet

When developing your homelab it's much more convinient to access your infrastructure 
dirrectly. This is why this step is usefull. Install tailscale on your PC and router
VM. Use tailscale dashboard to make this step easier (only for router).

```sh
curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=your auth key generated in dashboard
```

Enable subnet advertising by using this command:

```sh
sudo tailscale set --advertise-routes=homelab network (in this case 10.10.10.0/24)
```

And approve it in tailscale UI, if it wasn't done automaticly. Detailed 
documentation can be found [here](https://tailscale.com/kb/1019/subnets).

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
