#!/bin/bash
set -e

# ========== CONFIG ==========
GPU="nvidia"  # options: nvidia, amd, intel
INSTALL_PROTON_GE=true
# ============================

echo ">> Updating system..."
sudo pacman -Syu --noconfirm

echo ">> Installing base gaming packages..."
sudo pacman -S --noconfirm steam lutris bottles gamemode mangohud \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  lib32-gamemode lib32-alsa-plugins alsa-plugins \
  vulkan-tools gamescope pipewire pipewire-pulse pipewire-alsa pipewire-jack \
  firefox

# GPU-specific setup
if [[ "$GPU" == "nvidia" ]]; then
  echo ">> Installing NVIDIA drivers and OpenCL..."
  sudo pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils opencl-nvidia
elif [[ "$GPU" == "amd" ]]; then
  echo ">> Installing AMD drivers..."
  sudo pacman -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
elif [[ "$GPU" == "intel" ]]; then
  echo ">> Installing Intel drivers..."
  sudo pacman -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel
else
  echo "!! Invalid GPU option: $GPU"
  exit 1
fi

echo ">> Installing DXVK, VKD3D, and winetricks..."
sudo pacman -S --noconfirm dxvk vkd3d winetricks

# Proton GE (GloriousEggroll)
if $INSTALL_PROTON_GE; then
  echo ">> Installing Proton GE via AUR..."
  yay -S --noconfirm proton-ge-custom
fi

echo ">> Installing Discord, Spotify, Heroic, OpenRGB, NoiceTorch (AUR)..."
yay -S --noconfirm discord spotify heroic-games-launcher-bin openrgb noicetorch

echo ">> Setting up PipeWire audio services..."
systemctl --user enable --now pipewire pipewire-pulse pipewire-alsa pipewire-jack

echo ">> Installing KDE Plasma Desktop Environment and enabling SDDM..."
sudo pacman -S --noconfirm plasma kde-applications
sudo systemctl enable sddm.service --now

echo ">> Reminder: To use Proton GE, launch Steam > Settings > Compatibility > Enable Steam Play"
echo ">> Reminder: DLSS requires nvngx_dlss.dll in the game directory or Wine prefix."
echo ">> Setting up environment defaults for MangoHud and GameMode..."

cat <<EOF > ~/.pam_environment
MANGOHUD=1
GAMEMODERUN=1
EOF

echo ">> DONE! Reboot and enjoy your optimized Arch Linux gaming and media setup with KDE Plasma!"
