#!/bin/bash

# Install tools in Manjaro OS

#variables
kernelv=`mhwd-kernel -li | grep -m 1 -o "linux[1-9]*"`
languages=(nodejs python rust ruby erlang elixir)

apps=(com.brave.Browser org.mozilla.firefox org.gnome.Boxes org.gimp.GIMP com.obsproject.Studio org.telegram.desktop com.github.tchx84.Flatseal org.onlyoffice.desktopeditors
org.videolan.VLC io.dbeaver.DBeaverCommunity com.discordapp.Discord io.beekeeperstudio.Studio org.zealdocs.Zeal net.agalwood.Motrix org.kde.gwenview )

echo "Update system"

sudo pacman-mirrors -c United_States 
yay -Syu --noconfirm 

#install tools

yay -S --noconfirm brightnessctl qemu-desktop libvirt edk2-ovmf virt-manager tmux the_silver_searcher musikcube-bin feh kitty flatpak neovim docker docker-compose wxwidgets-gtk3 base-devel unixodbc fop unzip restic nftables ufw getnf


#Install virtualbox
if [ -z `virtualbox -v` ]; then
	yay -S --noconfirm  virtualbox  $kernelv-virtualbox-host-modules && sudo vboxreload 
#	sudo vboxreload && sudo modprobe vboxguest vboxvideo vboxsf &&  sudo systemctl enable --now vboxservice.service 
#	sudo gpasswd -a $USER vboxusers && sudo gpasswd -a $USER vboxsf
#	mkdir $HOME/vm-shared && chmod 755 -R $HOME/vm-shared/
else
	echo "Virtualbox are installed, continued...."
fi

unset kernelv

#install asdf

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
echo . "$HOME/.asdf/asdf.sh" >> $HOME/.bashrc 
echo . "$HOME/.asdf/completions/asdf.bash" >> $HOME/.bashrc && source $HOME/.bashrc
echo . "$HOME/.asdf/asdf.sh" >> $HOME/.zshrc && source $HOME/.zshrc


# Install plugins asdf

for ((count=0; count < 6; count++))
do
	asdf plugin add ${languages[count]}
	asdf install ${languages[count]} latest
	asdf global ${languages[count]} latest 
done

unset languages[*]


# Install Lunarvim

LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

echo export PATH=$PATH:$HOME/.local/bin && source $HOME/.zshrc

# Install nerdfonts

#curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
getnf

# Install applications

for ((counter=0; counter < 15; counter++))
do
  flatpak install -y ${apps[counter]}
done

unset apps[*]

echo "System Ready! Please reboot"

