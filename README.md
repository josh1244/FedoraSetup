# 🐧 Fedora Setup Guide

This guide outlines the steps to set up your Fedora system with custom configurations and enhancements.

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

### 🧩 Gnome Extensions

Install extensions:

```bash
sudo dnf install gnome-extensions-app gnome-shell-extension-blur-my-shell gnome-shell-extension-just-perfection gnome-shell-extension-caffeine
```

**Additional extensions:**

- [Vitals](https://extensions.gnome.org/extension/1460/vitals/)
- [Gesture Improvements](https://extensions.gnome.org/extension/4245/gesture-improvements/)
- [Quick Settings Tweaks](https://github.com/qwreey/quick-settings-tweaks)

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

### 🌍 Custom DNS Servers

```bash
sudo mkdir -p '/etc/systemd/resolved.conf.d'
sudo nano '/etc/systemd/resolved.conf.d/99-dns-over-tls.conf'
```

Add the following:

```
[Resolve]
DNS=1.1.1.2#security.cloudflare-dns.com 1.0.0.2#security.cloudflare-dns.com 2606:4700:4700::1112#security.cloudflare-dns.com 2606:4700:4700::1002#security.cloudflare-dns.com
DNSOverTLS=yes
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

---

## 🔍 6. Things to Look For

- Equivalent of Windows `Win + .` for symbols.
