#!/usr/bin/env bash

# =========================================================
# TOKYONIGHT + CATPPUCCIN HYBRID INSTALLER (FIXED)
# Cinnamon / WSL / Ubuntu / Debian
# Python 3.14 compatible
# =========================================================

set -e

echo "========================================="
echo " TOKYONIGHT + CATPPUCCIN INSTALLER"
echo "========================================="

# =========================================================
# PACKAGES
# =========================================================

echo ""
echo "Installing packages..."

sudo apt update

sudo apt install -y \
git \
curl \
wget \
unzip \
kitty \
zsh \
picom \
rofi \
fastfetch \
feh \
playerctl \
lxappearance \
dconf-editor \
fonts-firacode \
network-manager-gnome \
sassc \
gtk2-engines-murrine

# =========================================================
# DIRECTORIES
# =========================================================

mkdir -p ~/.config
mkdir -p ~/.themes
mkdir -p ~/.icons
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/fonts

# =========================================================
# CATPPUCCIN GTK (PREBUILT VERSION)
# =========================================================

echo ""
echo "Installing Catppuccin GTK..."

cd /tmp

rm -rf Catppuccin-Mocha-Blue*

wget \
https://github.com/catppuccin/gtk/releases/download/v1.0.0-rc5/catppuccin-mocha-blue-standard+default.zip

unzip -o catppuccin-mocha-blue-standard+default.zip

cp -r catppuccin-mocha-blue-standard+default ~/.themes/

# =========================================================
# GTK4 FIX
# =========================================================

echo ""
echo "Applying GTK4 fixes..."

mkdir -p ~/.config/gtk-4.0

THEME="$HOME/.themes/Catppuccin-Mocha-Blue"

ln -sf $THEME/gtk-4.0/assets ~/.config/gtk-4.0/assets
ln -sf $THEME/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
ln -sf $THEME/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

# =========================================================
# TOKYONIGHT ICONS
# =========================================================

echo ""
echo "Installing TokyoNight icons..."

cd ~/.local/share/icons

wget -O TokyoNight-SE.tar.bz2 \
https://github.com/ljmill/tokyo-night-icons/releases/latest/download/TokyoNight-SE.tar.bz2

tar -xvf TokyoNight-SE.tar.bz2

# =========================================================
# BIBATA CURSOR
# =========================================================

echo ""
echo "Installing Bibata cursor..."

cd ~/.icons

wget -O Bibata-Modern-Ice.tar.xz \
https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.xz

tar -xvf Bibata-Modern-Ice.tar.xz

# =========================================================
# NERD FONT
# =========================================================

echo ""
echo "Installing JetBrainsMono Nerd Font..."

cd ~/.local/share/fonts

wget -O JetBrainsMono.zip \
https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

unzip -o JetBrainsMono.zip

fc-cache -fv

# =========================================================
# KITTY
# =========================================================

echo ""
echo "Configuring Kitty..."

mkdir -p ~/.config/kitty

cd ~/.config/kitty

curl -LO \
https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/tokyo_night.conf

mv tokyo_night.conf tokyo-night.conf

cat > ~/.config/kitty/kitty.conf << 'EOF'
font_family JetBrainsMono Nerd Font
font_size 12

background_opacity 0.90

window_padding_width 12

cursor_shape beam

confirm_os_window_close 0

enable_audio_bell no

include tokyo-night.conf
EOF

# =========================================================
# PICOM
# =========================================================

echo ""
echo "Configuring Picom..."

mkdir -p ~/.config/picom

cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";

vsync = true;

corner-radius = 14;

shadow = true;

shadow-radius = 20;

shadow-opacity = 0.4;

blur:
{
  method = "dual_kawase";
  strength = 8;
}

inactive-opacity = 0.95;

active-opacity = 1.0;

fade = true;
EOF

# =========================================================
# ROFI
# =========================================================

echo ""
echo "Configuring Rofi..."

mkdir -p ~/.config/rofi

cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "drun";
    show-icons: true;
    font: "JetBrainsMono Nerd Font 12";
}

window {
    width: 35%;
    border-radius: 14px;
}
EOF

# =========================================================
# STARSHIP
# =========================================================

echo ""
echo "Installing Starship..."

curl -sS https://starship.rs/install.sh | sh -s -- -y

mkdir -p ~/.config

cat > ~/.config/starship.toml << 'EOF'
add_newline = false

format = """
[╭─](#7aa2f7)$directory$git_branch$git_status
[╰─❯](#cba6f7) """

[directory]
style = "bold #89b4fa"

[git_branch]
style = "bold #cba6f7"

[git_status]
style = "#f38ba8"
EOF

# =========================================================
# OH MY ZSH
# =========================================================

echo ""
echo "Installing Oh My Zsh..."

RUNZSH=no sh -c \
"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(
  git
  sudo
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

export MOZ_ENABLE_WAYLAND=1
export LIBGL_ALWAYS_SOFTWARE=1

alias ll='ls -lah'

pgrep picom >/dev/null || picom &
EOF

chsh -s $(which zsh)

# =========================================================
# APPLY THEMES
# =========================================================

echo ""
echo "Applying Cinnamon themes..."

gsettings set org.cinnamon.desktop.interface gtk-theme \
"Catppuccin-Mocha-Blue"

gsettings set org.cinnamon.desktop.interface icon-theme \
"TokyoNight-SE"

gsettings set org.cinnamon.desktop.interface cursor-theme \
"Bibata-Modern-Ice"

# =========================================================
# FASTFETCH
# =========================================================

mkdir -p ~/.config/fastfetch

fastfetch --gen-config

# =========================================================
# DONE
# =========================================================

echo ""
echo "========================================="
echo " INSTALL COMPLETE"
echo "========================================="
echo ""
echo "Restart Cinnamon:"
echo ""
echo "wsl --shutdown"
echo ""
echo "Then start Cinnamon again and Ubuntu 26.04:"
echo ""
echo "Enjoy your TokyoNight + Catppuccin setup!"
echo ""
