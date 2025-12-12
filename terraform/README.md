# Setup

I run Talos OS in my homelab. When I managed to set it up correctly it's just 
phenomenal. Running kubernetes on Talos is as easy as it can get. I just download
ISO file from [Talos Factory](https://factory.talos.dev/) to my proxmox local
storage with name `talos-amd64.iso` and then I follow steps bellow:

1. Create `.env` file with this variables:

```sh
export PM_API_URL="https://{proxmox_ip}:8006/api2/json"
export PM_API_TOKEN_ID='{proxmox_user}@pam!{token_name}'
export PM_API_TOKEN_SECRET="{token_secret}"
```

2. Then create `terraform.tfvars` with requested values in `variables.tf` file.

3. And finally I just run:

```sh
# To install dependencies
terraform init
```
```sh
# To create VMs
terraform apply
```
```sh
# To destroy cluster
terraform destroy
```
