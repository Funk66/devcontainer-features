# opencode (config)

Drops a **global** [opencode](https://opencode.ai) config at `~/.config/opencode/opencode.json` that points at a local, OpenAI-compatible inference endpoint. By default this is `http://mbp-m4:1236/v1` (LM Studio / Bionic), so opencode routes to your local model out of the box.

## Usage

```json
{
  "features": {
    // Installs the opencode binary from GitHub releases
    "ghcr.io/devcontainer-community/devcontainer-features/opencode.ai": {
      "version": "1.18.32"
    },
    // This feature: writes the config (runs after the install, via installsAfter)
    "ghcr.io/funk66/devcontainer-features/opencode": {
      "host": "mbp-m4",
      "port": "1236"
    }
  }
}
```
