# My setup

My personal homelab setup with detailed description how everything works.

## Network

Since now I have access to Ubiquiti Cloud Gateway (♥️  for Ubiquiti) I can 
easly create VLANs. So now my network diagram looks like this:

```txt
       WAN
        |
        |
+---------------+
| Cloud Gateway | Homelab VLAN: 10.0.0.0
+---------------+
        |
        |
+------------------+
| Flex Mini Switch |-------------------------+
+------------------+                         |
        |                                    |
        |                                    |
+-------------------------------+   +-----------------+
| My old laptop running Proxmox |   | Raspberry Pi 4B |
+-------------------------------+   +-----------------+
```

In Network tab I created Homelab VLAN and reserved DHCP range for it. 

## Nodes setup

I create VMs using instruction found in `terraform` module. Because now I know MAC 
addresses of my nodes so I can reserve static IPs for them in my Homelab network.
When it comes to raspberry pi, just go to [talos factory](https://factory.talos.dev/)
and select single-board computer, flash disk image on SD card or SSD if you have
one and boot raspberry pi while it's connected to switch. I also change settings
on port, so that my pi is only accepting traffic with my VLAN tag.

## Optional Step - Tailscale access to subnet

When developing your homelab it's much more convinient to access your infrastructure 
dirrectly. This is why this step is usefull. Install tailscale on your PC and proxmox
server. Use tailscale dashboard to make this step easier (only for server).

```sh
curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --auth-key=your auth key generated in dashboard
```

Enable subnet advertising by using this command:

```sh
sudo tailscale set --advertise-routes=homelab network (in this case 10.0.0.0/24)
```

And approve it in tailscale UI, if it wasn't done automaticly. Detailed 
documentation can be found [here](https://tailscale.com/kb/1019/subnets).

### Usefull template for me (not needed in whole cluster)

Requirements:
- [Ubuntu Cloud Image](https://cloud-images.ubuntu.com/noble/current) install it in **local storage** tab.
- Free RAM and disk space on your proxmox machine

Any params can be used, this are just examples.

```sh
qm create 9000 --name ubuntu-cloud --memory 1024 --cores 1
```

Attach disk Image:

```sh
 qm importdisk 9000 /var/lib/vz/template/iso/noble-server-cloudimg-amd64.img local-lvm
```

Create VM disk:

```sh
qm set 9000 --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-9000-disk-0
```

Resize disk as you connected:

```sh
qm resize 9000 virtio0 10G
```

In this template VM Hardware tab add `CloudInit Drive` and set correct boot order:

```sh
qm set 9000 --boot order="ide2;virtio0"
```

Set correct socket to se cloud-init output:

```sh
qm set 9000 --serial0 socket --vga serial0
```

## Encryption

Create or use existing age key.

```sh
age-keygen -o age.agekey
```

Create secret in kubernetes:

```sh
cat age.agekey |
kubectl create secret generic sops-age \
--namespace=flux-system \
--from-file=age.agekey=/dev/stdin
```

I use this sops-age command to decrypt files which is just simple:

```sh
alias sops-age="export SOPS_AGE_KEY_FILE=./age.agekey && sops"
```
