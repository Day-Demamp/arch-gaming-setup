#!/bin/bash
set -e

# ========== CONFIG ==========
GPU="nvidia"  # options: nvidia, amd, intel
INSTALL_PROTON_GE=true
# ============================

echo ">> Updating system..."
yay -Syu --noconfirm

echo ">> Installing base gaming and media packages..."
yay -S --noconfirm \
  steam lutris bottles gamemode mangohud \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  lib32-gamemode lib32-alsa-plugins alsa-plugins \
  vulkan-tools gamescope \
  pipewire pipewire-pulse pipewire-alsa pipewire-jack \
  firefox

# GPU-specific setup
case "$GPU" in
  nvidia)
    echo ">> Installing NVIDIA drivers and OpenCL..."
    yay -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils opencl-nvidia
    ;;
  amd)
    echo ">> Installing AMD drivers..."
    yay -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
    ;;
  intel)
    echo ">> Installing Intel drivers..."
    yay -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel
    ;;
  *)
    echo "!! Invalid GPU option: $GPU"
    exit 1
    ;;
esac

echo ">> Installing DXVK, VKD3D, and winetricks..."
yay -S --noconfirm dxvk vkd3d winetricks

# Proton GE (GloriousEggroll)
if [ "$INSTALL_PROTON_GE" = true ]; then
  echo ">> Installing Proton GE via AUR..."
  yay -S --noconfirm proton-ge-custom
fi

echo ">> Installing Discord, Spotify, Heroic, OpenRGB, NoiceTorch (AUR)..."
yay -S --noconfirm discord spotify heroic-games-launcher-bin openrgb noicetorch

echo ">> Enabling PipeWire audio services (user-level)..."
systemctl --user enable --now pipewire.service pipewire-pulse.service

echo ">> Installing KDE Plasma Desktop Environment and enabling SDDM..."
yay -S --noconfirm plasma kde-applications
sudo systemctl enable sddm.service --now

echo ">> Setting up environment defaults for MangoHud and GameMode..."
mkdir -p ~/.config/environment.d
cat <<EOF > ~/.config/environment.d/gaming.conf
MANGOHUD=1
GAMEMODERUN=1
EOF

echo ">> DONE!"
echo ">> REBOOT and enjoy your optimized Arch Linux gaming and media setup with KDE Plasma."
echo ">> Reminder: Enable Steam Play in Steam > Settings > Compatibility > Enable Steam Play"
echo ">> Reminder: DLSS requires 'nvngx_dlss.dll' in game directory or Wine prefix."
