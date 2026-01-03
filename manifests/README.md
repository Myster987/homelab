# Kubernetes with GitOps

To begin install Flux CLI:

```sh
brew install fluxcd/tap/flux
```

Get your Github access credentials in your [github.com](https://github.com) 
developer settings. Select PAT and fine-grained tokens to generate token only
for this specific repo. Add this permissions:

### Read access to:
- metadata

### Read and Write access to:
- dependabot alerts
- actions
- administration
- code
- commit statuses
- dependabot secrets
- deployments
- discussions
- environments
- issues
- merge queues
- pull requests
- repository advisories
- repository hooks
- secret scanning alerts
- secrets
- security events
- workflows

Then export this two credentials (I like to save them in `.env` file):

```sh
export GITHUB_USER=your-username
export GITHUB_TOKEN=your-token
```

Enable gateway API for cilium:

```sh
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml  
```

Bootstrap command:

```sh
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=homelab \
  --branch=main \
  --path=./manifests/cluster \
  --personal \
  --kubeconfig=./kubeconfig.yaml
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

## Cloudflare tunnel

To setup cloudflare tunnel follow [this guide](https://artifacthub.io/packages/helm/community-charts/cloudflared).
When tunnel is created it stores tokens and certs in this directory: `~/.cloudflared`.
Don't forget to later encrypt them with sops!
