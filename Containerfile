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
  && sed -i 's/^#\s*set -o vi/set -o vi/' /etc/bash.bashrc \
  && ssh-keyscan -t ed25519,rsa,ecdsa github.com >> /etc/ssh/ssh_known_hosts \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=C.UTF-8


COPY --chown=ubuntu:ubuntu dotfiles/gitconfig /home/ubuntu/.gitconfig
COPY --chown=ubuntu:ubuntu dotfiles/opencode.json /home/ubuntu/.config/opencode/opencode.json

# hadolint ignore=DL3066
USER ubuntu
# hadolint ignore=DL4006
RUN mkdir -p ~/.local/share/nvim ~/.local/state/nvim ~/.local/state/opencode \
  && git clone --depth 1 https://github.com/funk66/vim ~/.config/nvim \
  && curl -fsSL https://opencode.ai/v2/install | bash

ENV PS1='\[\e[32m\]\w\[\e[0m\]|> '
ENV PATH="/home/ubuntu/.opencode/bin:$PATH"

WORKDIR /home/ubuntu
CMD ["sleep", "infinity"]
