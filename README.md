# My setup

My personal homelab setup with detailed description how everything works. My plan
is to make this repo easy to deploy and reproduce if needed. Some design choises
are bad, but this isn't production grad, so it's fine.

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
When it comes to raspberry pi, I installed pxvirt which is proxmox adaptation to work
on arm. Resources are quire limited, but this alows me to simply delete vm when I break
something, so laziness won in this case.

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
