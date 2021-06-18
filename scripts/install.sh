#!/usr/bin/env bash

for ARG in "$@"; do
  LOWER_ARG="$(tr '[:upper:]' '[:lower:]' <<< "$ARG")"
  [[ "$LOWER_ARG" == "--help" ]] ||
  [[ "$LOWER_ARG" == "-help" ]] ||
  [[ "$LOWER_ARG" == "help" ]] ||
  [[ "$LOWER_ARG" == "--h" ]] ||
  [[ "$LOWER_ARG" == "-h" ]] ||
  [[ "$LOWER_ARG" == "h" ]] ||
  [[ "$LOWER_ARG" == "--?" ]] ||
  [[ "$LOWER_ARG" == "-?" ]] ||
  [[ "$LOWER_ARG" == "?" ]] &&
  echo "installs rootless docker (with dependencies) and pi-docker systemd unit"
done

BIN_IN_PATH="false"
IFS=':' read -a BIN_DIRS <<< "$PATH"
for BIN_DIR in "${BIN_DIRS[@]}"; do
  [[ "$BIN_DIR" == "/home/$(whoami)/bin" ]] ||
  [[ "$BIN_DIR" == "~/bin" ]] &&
  BIN_IN_PATH="true"
done

if "$BIN_IN_PATH"; then
  echo "~/bin detected in path, won't modify rc files"
else
  echo "~/bin not detected in path, adding to .bashrc and .zshrc"
  [ -f ~/.bashrc ] && echo 'PATH=~/bin:$PATH' >> ~/.bashrc
  [ -f ~/.zshrc ] && echo 'PATH=~/bin:$PATH' >> ~/.zshrc
  [ -f ~/.bashrc ] || [ -f ~/.zshrc ] || {
    echo "neither ~/.basrc or ~/.zshrc exist, guessing you use bash"
    echo 'PATH=~/bin:$PATH' >> ~/.bashrc
  } 
fi

[ ! -f ~/bin ] && mkdir ~/bin

echo "Installing docker rootless dependencies..."
curl -o slirp4netns --fail -L https://github.com/rootless-containers/slirp4netns/releases/download/v1.1.10/slirp4netns-$(uname -m) && chmod +x slirp4netns && mv~/bin

echo "Installing docker"
curl -fsSL https://get.docker.com/rootless | sh

echo "Installing pi-docker systemd unt"
cp ../pi-docker.service ~/.config/systemd/user/pi-docker.service

echo "done, to start pi-docker now use:"
echo 'systemd start --user pi-docker'
echo ""
echo "and to have it run on login use:"
echo 'systemd enable --user pi-docker'

