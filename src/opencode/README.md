# opencode (config)

Drops a **global** [opencode](https://opencode.ai) config at `~/.config/opencode/opencode.json` that points at a local, OpenAI-compatible inference endpoint. By default this is `http://mbp-m4:1236/v1` (LM Studio / Bionic), so opencode routes to your local model out of the box.

## Usage

```json
{
  "features": {
    "ghcr.io/funk66/devcontainer-features/opencode": {
      "host": "mbp-m4",
      "port": "1236"
    }
  }
}
```
