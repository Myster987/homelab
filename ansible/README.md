# Ansible automation

This module is responsible for bootstraping Talos cluster on my machines.

## Dependencies installation

In project directory I create virtual environment using **uv** cli.

```sh
# Run this in project root
uv venv
```

And install Ansible:

```sh
uv pip install ansible
```

Load Python to current shell:

```sh
source .venv/bin/activate
```

## Ansible Inventory

In `ansible/inventory/hosts.ini` I need to set correct IPs for my nodes. It's
very important to reserve those IPs for Talos nodes to don't run into any issues
when DHCP would change them. In Ubiquiti dashboard it's simple. For example in
topology view, click on node, go to settings and check *Fixed IP Address*.

## Running automation

Before I will run finall automation script I need to make sure that `talos/config`
directory doesn't exist because it would skip apply command and it's not ideal.

After that I can run:

```sh
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/configure-cluster.yaml
```

This script will generate config, boostrap Talos cluster and get `kubeconfig.yaml`,
which can be used to manipulate cluster state.

## Note

Talos takes a while to initialize, so be patient and `kubectl get nodes` 
should return *Ready* state soon.
