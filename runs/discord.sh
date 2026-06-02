#!/bin/bash
# Install Discord on Pop!_OS

install_flatpak() {
    flatpak install -y flathub com.discordapp.Discord
}

install_deb() {
    wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    sudo apt install /tmp/discord.deb
    rm /tmp/discord.deb
}

case "$1" in
    --deb)
        echo "Installing via .deb..."
        install_deb
        ;;
    *)
        echo "Installing via Flatpak..."
        install_flatpak
        ;;
esac
