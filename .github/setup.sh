#!/bin/bash

# Create home subdirectories
echo -e "\e[32mCreating home subdirectories\e[0m"
mkdir -p "$HOME/Documents" "$HOME/Downloads" "$HOME/Music" "$HOME/Pictures" "$HOME/programming/projects" "$HOME/temp"

# Install yay if not installed
if ! command -v yay > /dev/null 2>&1; then
	echo -e "\e[32mInstalling yay\e[0m"
	sudo pacman -S --needed git base-devel
	[ -d "$HOME/Downloads/yay" ] && rm -rf "$HOME/Downloads/yay"
	git clone https://aur.archlinux.org/yay.git "$HOME/Downloads/yay"
	(cd "$HOME/Downloads/yay" && makepkg -si)
	rm -rf "$HOME/Downloads/yay"
fi

# Clone and checkout dotfiles
echo -e "\e[32mCloning and checking out dotfiles\e[0m"
if ! git clone --bare https://github.com/mcttn22/dotfiles.git "$HOME/.dotfiles"; then
	echo -e "\e[31mError:\e[0m Failed to clone dotfiles repository"
	exit 1
fi
if ! git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout; then
	echo -e "\e[31mError:\e[0m Failed to checkout dotfiles"
	rm -rf "$HOME/.dotfiles"
	exit 1
fi
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config --local status.showUntrackedFiles no

# Sync and update current packages
echo -e "\e[32mSyncing and updating current packages\e[0m"
yay -Syu

# Installed required packages
echo -e "\e[32mInstalling required packages\e[0m"
yay -S --needed \
	sddm \
	sddm-theme-sugar-candy-git \
	hyprland \
	xorg-xwayland \
	pipewire \
	pipewire-audio \
	pipewire-alsa \
	pipewire-pulse \
	wireplumber \
	pavucontrol \
	xdg-desktop-portal-hyprland \
	qt5-wayland \
	qt6-wayland \
	orchis-theme \
	hyprpaper \
	hypridle \
	hyprlock \
	wlogout \
	polkit-gnome \
	brightnessctl \
	networkmanager \
	network-manager-applet \
	playerctl \
	wl-clipboard \
	cliphist \
	waybar \
	waybar-module-pacman-updates-git \
	wttrbar \
	wofi \
	kitty \
	nemo \
	firefox \
	cmus \
	cava \
	discord \
	fastfetch \
	nerd-fonts \
	noto-fonts-emoji \
	grim \
	slurp \
	dunst \
	neovim \
	ripgrep \
	npm

# Apply sddm theme
echo -e "\e[32mApply sddm theme\e[0m"
sudo cp ~/.config/sddm/themes/Sugar-Candy/theme.conf /usr/share/sddm/themes/Sugar-Candy/theme.conf.user
echo -e "[Theme]\n\nCurrent=Sugar-Candy\n" | sudo tee /etc/sddm.conf > /dev/null

# Apply gtk theme and font
echo -e "\e[32mApply gtk theme and font\e[0m"
gsettings set org.gnome.desktop.interface gtk-theme Orchis-Dark
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font"

# Enable network manager service for nm applet
echo -e "\e[32mEnable and start NetworkManager service for NM applet\e[0m"
sudo systemctl enable --now NetworkManager

# Start pipewire pulse service
echo -e "\e[32mStart pipewire pulse service\e[0m"
systemctl start --user pipewire-pulse

# Enable sddm service
echo -e "\e[32mEnable and start sddm service\e[0m"
sudo systemctl enable --now sddm

