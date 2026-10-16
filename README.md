# Devcontainers

## Deployment

```sh
coder templates push $TEMPLATE \
  --directory coder/devcontainer \
  --icon /icon/docker.svg \
  --name "$(git rev-parse --short HEAD)"
```

## Usage

```json
{
  "name": "my-project",
  "image": "ghcr.io/funk66/devcontainers:latest"
}
```
