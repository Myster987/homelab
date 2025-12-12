# Setup

Create `.env` file with this variables:

```sh
export PM_API_URL="https://{proxmox_ip}:8006/api2/json"
export PM_API_TOKEN_ID='{proxmox_user}@pam!{token_name}'
export PM_API_TOKEN_SECRET="{token_secret}"
```

Then create `terraform.tfvars` with requested values in `variables.tf` file
and you should be good to go.

### Just run:

To install dependencies:
```sh
terraform init
```
To create VMs:
```sh
terraform apply
```
To destroy cluster:
```sh
terraform destroy
```
