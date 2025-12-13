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
