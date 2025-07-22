#!/bin/bash
set -e

# ========== CONFIG ==========
GPU="nvidia"  # options: nvidia, amd, intel
INSTALL_PROTON_GE=true
# ============================

echo ">> Updating system..."
yay -Syu --noconfirm

echo ">> Removing JACK2 (conflicts with pipewire-jack)..."
sudo pacman -Rns --noconfirm jack2 || true

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
