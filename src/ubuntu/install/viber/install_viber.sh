#!/usr/bin/env bash
set -ex

# Install Viber
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')
if [ "${ARCH}" == "arm64" ] ; then
    echo "Viber for arm64 currently not supported, skipping install"
    exit 0
fi

# Download and install Viber
wget -O /tmp/viber.deb https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
apt-get update
apt-get install -y /tmp/viber.deb

# Desktop icon
cp /usr/share/applications/viber.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/viber.desktop

# Cleanup for app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
fi