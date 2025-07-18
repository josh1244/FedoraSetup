# 🐧 Fedora Setup Guide

![Fedora Setup Banner](https://placehold.co/1200x300.png?text=Fedora+Setup+Guide)  
_A comprehensive guide on setting up Fedora to my liking._

---

## 📖 Table of Contents

1. [System Updates and Repositories](#-1-system-updates-and-repositories)
2. [Firmware Updates](#-2-firmware-updates)
3. [Media and Hardware Configuration](#-3-media-and-hardware-configuration)
4. [Desktop Environment Customization](#-4-desktop-environment-customization)
5. [Additional Configurations](#-5-additional-configurations)
6. [Automated Setup Script](#-automated-setup-script)
---

## 📦 1. System Updates and Repositories

### 🔄 Update System and Core Packages

```bash
sudo dnf group upgrade core
sudo dnf4 group update core
sudo dnf -y update
```

### 🌐 Setup Third-Party Repositories

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

### 🖥️ Install Zen Browser

Install the Zen browser using Flatpak:

```bash
flatpak install flathub app.zen_browser.zen
```

---

## 🔧 2. Firmware Updates

```bash
sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

---

## 🎥 3. Media and Hardware Configuration

### 🎵 Media Codecs

```bash
sudo dnf4 group upgrade multimedia
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf group install -y sound-and-video
```

### 🖥️ Hardware Video Acceleration

```bash
sudo dnf install ffmpeg-libs libva libva-utils
sudo dnf swap libva-intel-media-driver intel-media-driver --allowerasing
sudo dnf install libva-intel-driver
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
```

**Enable OpenH264 in Firefox:**

1. Open `about:addons` in Firefox.
2. Enable the OpenH264 plugin.

---

## 🖌️ 4. Desktop Environment Customization

### 🎨 Grub Theme: Elegant-grub2-themes

```bash
sudo dnf install redhat-lsb
git clone https://github.com/vinceliuice/Elegant-grub2-themes.git
cd Elegant-grub2-themes
sudo ./install.sh -t wave -c light -s 2k -l system -b
```

### 🎨 Bibata Cursor Theme

Install the Bibata cursor theme:

```bash
sudo dnf copr enable peterwu/rendezvous
sudo dnf install bibata-cursor-themes
```
Set the Bibata cursor theme in 'Tweaks > Appearance > Cursor'.

### 🛠️ Gnome Tweaks

Install Gnome Tweaks:

```bash
sudo dnf install gnome-tweak-tool
gnome-tweaks
```

#### 🚫 Stop Software Autolaunch

```bash
sudo rm /etc/xdg/autostart/org.gnome.Software.desktop
```

#### ⌨️ Add Keyboard Shortcuts

1. Open `Settings > Keyboard > Shortcuts`.
2. Add the following custom shortcuts:
   - **Ctrl+Alt+T**: `ptyxis --tab`
   - **Super+Q**: Close Window
   - **Disable Notification List**: Unbind `vShow the Notification List`.
   - **Clipboard Indicator Toggle**: `Super+V`.

#### 🔋 Show Battery Percentage

1. Navigate to `Settings > Power`.
2. Enable **Show Battery Percentage**.

#### ❌ Disable Hot Corners

1. Go to `Settings > Multitasking`.
2. Set **Hot Corner** to `false`.

#### 🌙 Night Light

1. Open `Settings > Night Light`.
2. Enable Night Light and set **Color Temperature** to `1/4`.

#### 🖱️ Configure Terminal Copy and Paste

To configure `Ctrl+C` and `Ctrl+V` for copy and paste in the terminal:

1. Open the terminal settings for **Ptyxis/Terminal**.
2. Navigate to the **Shortcuts** section.
3. Set the following keybindings:
   - **Copy**: `Ctrl+C`
   - **Paste**: `Ctrl+V`
4. Save the changes and restart the terminal if necessary.

## 🖥️ 5. Dotfiles and Configurations

### 🐚 Setting up Zsh and Oh My Zsh

Install and configure Zsh as the default shell:

```bash
# Install Zsh
sudo dnf install -y zsh

# Set Zsh as the default shell
chsh -s $(which zsh)
### 🚀 Install Oh My Zsh and Plugins

#### Install Oh My Zsh

```bash
if [ ! -d "$HOME/.oh-my-zsh" ]; then
   echo "Installing Oh My Zsh..."
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
   echo "Oh My Zsh is already installed."
fi
```

#### Add Plugins

- **zsh-syntax-highlighting**: Provides syntax highlighting for commands.
  
  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

- **zsh-autosuggestions**: Suggests commands as you type based on history and completions.

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```

#### Install Spaceship Prompt Theme

- Clone the repository to the Zsh custom theme directory:

  ```bash
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ```

- Create a symlink for the theme:

  ```bash
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  ```s

### 📂 Setup Dotfiles and `.config` Directory

Replace the existing `.config` directory and set up symlinks for dotfiles:

```bash
# Remove existing .config directory and replace it with a symlink
rm -rf ~/.config
ln -sf /home/josh/repos/FedoraSetup/config ~/.config

# Symlink other dotfiles
ln -sf /home/josh/repos/FedoraSetup/zshrc ~/.zshrc
ln -sf /home/josh/repos/FedoraSetup/zshrc.pre-oh-my-zsh ~/.zshrc.pre-oh-my-zsh

echo "Zsh, Oh My Zsh, dotfiles, and .config directory set up successfully!"
```

### 🧩 Gnome Extensions

Install extensions:

```bash
sudo dnf install gnome-extensions-app gnome-shell-extension-blur-my-shell gnome-shell-extension-just-perfection gnome-shell-extension-caffeine
```

**Additional extensions:**

- [Vitals](https://extensions.gnome.org/extension/1460/vitals/)
- [Gesture Improvements](https://extensions.gnome.org/extension/4245/gesture-improvements/)
- [Quick Settings Tweaks](https://github.com/qwreey/quick-settings-tweaks)
- [Touchpad Gesture Customization](https://extensions.gnome.org/extension/7850/touchpad-gesture-customization/)
- [Framework Laptop Control] (https://github.com/stefanhoelzl/frameworkd)

**Configure Blur My Shell:**

1. Open the **Blur My Shell** settings.
2. In **Applications**, Add zen to the whitelist.
3. Disable the **Opaque on Focus** option.

---

## ⚙️ 5. Additional Configurations

### 🖥️ Set Hostname

```bash
hostnamectl set-hostname joshs-framework
```

### 🌐 Default Firefox Start Page

```bash
sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
```

### 🕒 Set UTC Time

```bash
sudo timedatectl set-local-rtc '0'
```

### 🚀 Disable NetworkManager-wait-online.service

```bash
sudo systemctl disable NetworkManager-wait-online.service
```

This can reduce boot time by ~15-20 seconds.

### 🖼️ HEIF Image Support

Install tools for HEIF image handling:

```bash
sudo dnf install -y libheif-tools
```

---

## 💾 Backup Solutions

For reliable backups, consider installing one of the following tools:

- **Pika Backup**
- **Deja Dup Backups**

Install via DNF:

```bash
sudo dnf install pika-backup deja-dup
```

Both tools provide easy graphical interfaces for scheduling and managing backups.

---

## 🛠️ Automated Setup Script

To automate the setup process, you can use the provided Bash script. Follow these steps:

### 📄 Script Location

The script is located in the repository as `setup_fedora.sh`.

### 🚀 How to Use

1. **Download or Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd FedoraSetup
   ```

2. **Make the Script Executable**:

   ```bash
   chmod +x setup_fedora.sh
   ```

3. **Run the Script**:
   ```bash
   ./setup_fedora.sh
   ```

### ⚠️ Notes

- Some steps in the script require manual interaction (e.g., enabling OpenH264 in Firefox, configuring GNOME settings).
- Ensure you have `sudo` privileges before running the script.
- Review the script to ensure it aligns with your specific setup needs.

---

```bash
# Example: Running the script
./setup_fedora.sh
```

---

## 📜 Additional Information

- **Fedora Version**: This guide is optimized for Fedora 38 and later.
- **Contributions**: Feel free to submit pull requests or issues to improve this guide.
- **License**: This guide is licensed under the MIT License.

---

Happy configuring your Fedora system! 🎉
