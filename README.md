# Requirements

Network (created in "Your node" -> System -> Network, don't forget to make it 
autostart):
- 192.168.1.x <-- home network (connected to physical port and existing gateway)
- 10.0.0.x <-- homelab network (only CIDR 10.0.0.1)

# Nodes setup

## 1. Router VM

Create VM that is connected to both networks (Proxmox -> Router vm -> Hardware
-> Network Device -> add both of them). In cloud-init set static ip in homelab
network to be 10.0.0.1 (as a gateway) and in home network dhcp can be used. \

(Switch config)[https://community.ui.com/questions/UniFi-OS-Server-Installation-Scripts-or-UniFi-Network-Application-Installation-Scripts-or-UniFi-Eas/ccbc7530-dd61-40a7-82ec-22b17f027776]

Next steps:

### Allow IP Forwarding

```sh
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w net.ipv4.ip_forward=1
```

### NAT Masquerading

```sh
sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.0/24 -j MASQUERADE
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
subnet 10.0.0.0 netmask 255.255.255.0 {
    range 10.0.0.x 10.0.0.y;
    option routers 10.0.0.1;
    option domain-name-servers 1.1.1.1, 8.8.8.8;
    
    # Example Static IP Reservations (set this after nodes are created)
    host homelab-cp-1 {
        hardware ethernet aa:bb:cc:dd:ee:ff;
        fixed-address 10.0.0.50;               
    }

    host homelab-cp-2 {
        hardware ethernet 11:22:33:44:55:66;
        fixed-address 10.0.0.51;
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
sudo tailscale set --advertise-routes=homelab network (in this case 10.0.0.0/24)
```

And approve it in tailscale UI, if it wasn't done automaticly. Detailed 
documentation can be found [here](https://tailscale.com/kb/1019/subnets).

## 2. Cluster Nodes

Requirements:
- [Ubuntu Cloud Image](https://cloud-images.ubuntu.com/noble/current) install it in **local storage** tab.
- Free RAM and disk space on your proxmox machine
- Hope and some sanity 😁

### Create VM that will be used as a template 

Any params can be used, this are just examples. Just make sure to update them accordingly.

```sh
qm create 9000 --name ubuntu-cloud --memory 1024 --cores 1
```

### Attach disk Image

```sh
 qm importdisk 9000 /var/lib/vz/template/iso/noble-server-cloudimg-amd64.img local-lvm
```

### Create VM disk

```sh
qm set 9000 --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-9000-disk-0
```

### Resize disk as you connected

```sh
qm resize 9000 virtio0 10G
```

### Set correct boot order

```sh
qm set 9000 --boot order="ide2;virtio0"
```

### Set correct socket to se cloud-init output 

```sh
qm set 9000 --serial0 socket --vga serial0
```

### Go to this new VM in proxmox UI

Now you can add cloud-init drive in hardware tab (set it to ide2, or any matching
device name). Although I think that terraform will set it for you in later steps.
