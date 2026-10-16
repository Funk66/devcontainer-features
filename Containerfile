# hadolint global ignore=DL3008
FROM ubuntu:26.04

ENV SHELL=/bin/bash LANG=C.UTF-8 EDITOR=nvim VISUAL=nvim NVIM_DEVCONTAINER=1

RUN apt-get update && apt-get install -y --no-install-recommends \
  bash \
  build-essential \
  ca-certificates \
  curl \
  fd-find \
  fzf \
  git \
  git-delta \
  jq \
  lazygit \
  locales \
  make \
  nodejs \
  neovim \
  npm \
  openssh-client \
  python3 \
  ripgrep \
  unzip \
  yq \
  xz-utils \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s "$(command -v fdfind)" /usr/local/bin/fd \
  && printf 'set -o vi\n' >> /etc/bash.bashrc \
  && printf 'PS1=\\[\\e[32m\\]\\w\\[\\e[0m\\]|> \\n' >> /etc/bash.bashrc \
  && ssh-keyscan -t ed25519,rsa,ecdsa github.com >> /etc/ssh/ssh_known_hosts \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8


COPY --chown=1000:1000 dotfiles/gitconfig /home/ubuntu/.gitconfig
COPY --chown=1000:1000 dotfiles/opencode.json /home/ubuntu/.config/opencode/opencode.json

USER 1000
# hadolint ignore=DL4006
RUN mkdir -p ~/.local/share/nvim ~/.local/state/nvim ~/.local/state/opencode \
  && git clone --depth 1 https://github.com/funk66/vim ~/.config/nvim \
  && curl -fsSL https://opencode.ai/v2/install | bash

ENV PATH="/home/ubuntu/.opencode/bin:$PATH"

WORKDIR /home/ubuntu
CMD ["sleep", "infinity"]