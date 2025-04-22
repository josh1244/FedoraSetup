#!/bin/bash

echo "Starting Fedora setup..."

# 1. System Updates and Repositories
echo "Updating system and core packages..."
sudo dnf group upgrade core -y
sudo dnf -y update

echo "Setting up third-party repositories..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installing Zen Browser..."
flatpak install -y flathub app.zen_browser.zen

# 2. Firmware Updates
echo "Updating firmware..."
sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update

# 3. Media and Hardware Configuration
echo "Installing media codecs..."
sudo dnf group upgrade multimedia -y
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing -y
sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf group install -y sound-and-video

echo "Setting up hardware video acceleration..."
sudo dnf install -y ffmpeg-libs libva libva-utils
sudo dnf swap libva-intel-media-driver intel-media-driver --allowerasing -y
sudo dnf install -y libva-intel-driver openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# 4. Desktop Environment Customization
echo "Installing Grub theme..."
sudo dnf install -y redhat-lsb
git clone https://github.com/vinceliuice/Elegant-grub2-themes.git
cd Elegant-grub2-themes
sudo ./install.sh -t wave -c light -s 2k -l system -b
cd ..

echo "Installing GNOME Tweaks..."
sudo dnf install -y gnome-tweak-tool

echo "Installing GNOME extensions..."
sudo dnf install -y gnome-extensions-app gnome-shell-extension-blur-my-shell gnome-shell-extension-just-perfection gnome-shell-extension-caffeine

echo "Installing HEIF image support..."
sudo dnf install -y libheif-tools

echo "Installing Bibata cursor theme..."
sudo dnf copr enable peterwu/rendezvous -y
sudo dnf install -y bibata-cursor-themes

# 5. Dotfiles and Configurations
echo "Setting up Zsh and Oh My Zsh..."

# Install Zsh
sudo dnf install -y zsh

# Set Zsh as the default shell
chsh -s $(which zsh)

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting is already installed."
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions is already installed."
fi

# Install Spaceship prompt
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt" ]; then
    echo "Installing Spaceship prompt..."
    git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
    ln -s "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
else
    echo "Spaceship prompt is already installed."
fi

echo "Setup Dotfiles and .config directory..."

# Remove existing .config directory and replace it with a symlink
rm -rf ~/.config
ln -sf /home/josh/repos/FedoraSetup/config ~/.config

# Symlink other dotfiles
ln -sf /home/josh/repos/FedoraSetup/zshrc ~/.zshrc
ln -sf /home/josh/repos/FedoraSetup/zshrc.pre-oh-my-zsh ~/.zshrc.pre-oh-my-zsh

echo "Zsh, Oh My Zsh, dotfiles, and .config directory set up successfully!"

# 6. Additional Configurations
echo "Setting hostname..."
sudo hostnamectl set-hostname joshs-framework

echo "Removing default Firefox start page..."
sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js

echo "Configuring custom DNS servers..."
sudo mkdir -p /etc/systemd/resolved.conf.d
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/99-dns-over-tls.conf
[Resolve]
DNS=1.1.1.2#security.cloudflare-dns.com 1.0.0.2#security.cloudflare-dns.com 2606:4700:4700::1112#security.cloudflare-dns.com 2606:4700:4700::1002#security.cloudflare-dns.com
DNSOverTLS=yes
EOF

echo "Setting UTC time..."
sudo timedatectl set-local-rtc 0

echo "Disabling NetworkManager-wait-online.service to reduce boot time..."
sudo systemctl disable NetworkManager-wait-online.service

# Manual Configuration Reminders
echo "=========================="
echo "Manual Configuration Reminders:"
echo "Reminder: Enable OpenH264 in Firefox manually by navigating to 'about:addons' and enabling the plugin."
echo "Reminder: Add custom keyboard shortcuts manually in 'Settings > Keyboard > Shortcuts'."
echo "Reminder: Configure Ptyxis/Terminal to use Ctrl+C and Ctrl+V for copy and paste..."
echo "Reminder: Enable 'Show Battery Percentage' in 'Settings > Power'."
echo "Reminder: Disable Hot Corners in 'Settings > Multitasking'."
echo "Reminder: Enable Night Light in 'Settings > Night Light' and set the color temperature to 1/4."
echo "Reminder: Open Blur My Shell settings, add 'zen' to the whitelist, and disable 'Opaque on Focus'."
echo "Reminder: Set the Bibata cursor theme in 'Tweaks > Appearance > Cursor'."
echo "Reminder: Install additional GNOME extensions manually:"
echo "- Vitals: https://extensions.gnome.org/extension/1460/vitals/"
echo "- Gesture Improvements: https://extensions.gnome.org/extension/4245/gesture-improvements/"
echo "- Quick Settings Tweaks: https://github.com/qwreey/quick-settings-tweaks"
echo "- Touchpad Gesture Customization: https://extensions.gnome.org/extension/7850/touchpad-gesture-customization/"

echo "Fedora setup complete! Some steps require manual configuration as noted."