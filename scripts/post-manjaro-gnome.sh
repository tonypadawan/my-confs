#!/bin/bash


# Install tools in Manjaro OS

#variables

apps=(org.telegram.desktop  org.mozilla.firefox net.agalwood.Motrix com.github.tchx84.Flatseal org.gnome.Evince org.onlyoffice.desktopeditors org.gnome.World.PikaBackup org.gnome.Boxes org.gnome.Loupe org.gnome.Logs org.gnome.Calculator org.gimp.GIMP com.obsproject.Studio org.videolan.VLC io.dbeaver.DBeaverCommunity com.discordapp.Discord io.beekeeperstudio.Studio org.zealdocs.Zeal com.brave.Browser org.gnome.baobab)
languages=(nodejs python rust ruby)


echo "Update system"

sudo chattr +C /var/log/

sudo pacman-mirrors -c United_States 
yay -Syu --noconfirm 

# Remove packages
yay -Rs --noconfirm firefox gnome-tour manjaro-starter evince sushi loupe gnome-logs gnome-calculator lollypop totem gnome-weather gnome-system-monitor  manjaro-hello

#install tools

yay -S --noconfirm  qemu-desktop libvirt edk2-ovmf virt-manager traceroute  nmap btop flatpak neovim docker docker-compose glu base-devel unzip nftables ufw getnf tmux the_silver_searcher musikcube-bin feh kittybase-devel restic timeshift timeshift-autosnap-manjaro ldns


#Install virtualbox

#	yay -S --noconfirm  virtualbox  {$kernelv}-virtualbox-host-modules virtualbox-guest-utils virtualbox-ext-oracle  
#	sudo vboxreload && sudo modprobe vboxguest vboxvideo vboxsf &&  sudo systemctl enable --now vboxservice.service 
#	sudo gpasswd -a $USER vboxusers && sudo usermod -aG vboxsf $USER
# sudo mkdir $HOME/vm-shared && sudo chmod 755 -R $HOME/vm-shared/

#install asdf


git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
echo . "$HOME/.asdf/asdf.sh" >> $HOME/.bashrc 
echo . "$HOME/.asdf/completions/asdf.bash" >> $HOME/.bashrc && source $HOME/.bashrc
echo . "$HOME/.asdf/asdf.sh" >> $HOME/.zshrc && source $HOME/.zshrc


# Install plugins asdf

for ((count=0; count < 4; count++))
do
	asdf plugin add ${languages[count]}
	asdf install ${languages[count]} latest
	asdf global ${languages[count]} latest
done

unset languages[*]

# Install Lunarvim

LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

echo export PATH=$PATH:$HOME/.local/bin >> $HOME/.zshrc && source $HOME/.zshrc


# Install nerdfonts

#curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
getnf

# Install applications

for ((counter=0; counter < 20; counter++))
do
  flatpak install -y ${apps[counter]}
done

unset apps[*]

# Groups
sudo usermod -aG docker $USER

# Enable services
#sudo systemctl enable --now nftables
#sudo systemctl enable --now ufw
sudo systemctl enable --now libvirtd
#sudo systemctl enable --now cups

echo "System Ready! Please reboot"

