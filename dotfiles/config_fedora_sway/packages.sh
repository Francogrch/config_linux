sudo dnf install alacritty wofi blueman-manager wlogout waybar zsh neovim zsh zoxide zsh-autosuggestions zsh-syntax-highlighting fzf bat tree fd lsd docker uv

chsh -s $(which zsh)

cd .config/sway
sudo dnf install python3-pip
python3 -m pip install --user tendo i3ipc

Fuente: Iosevka Nerd Font
mkdir -p ~/.local/share/fonts
cp ~/Descargas/mi-fuente.ttf ~/.local/share/fonts/
fc-cache -fv


vesktop
dbdeader
vscode
oh-my-zsh
powerlevel10k

git clone zsh-autocomplete
cp -r zsh-autocomplete /usr/share

## Dark mode 
nvim ~/.config/gtk-3.0/settings.ini

[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita



