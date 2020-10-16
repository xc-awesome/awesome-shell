#!/bin/bash
echo  ::::::: Begin installing and configuring jumpuser users :::::::

echo Yum install zsh ...
sudo yum install zsh -y

echo Yum install git
sudo yum install git -y

echo Yum install oh my zsh
sudo sh -c "$(curl -fsSL  https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)" "" --unattended

echo Git clone oh my zsh plugin for zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo Git clone oh my zsh plugin for zsh-syntax-highlighting
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo Git clone oh my zsh plugin for autojump
sudo git clone git://github.com/wting/autojump.git  $ZSH_CUSTOM/plugins/autojump

echo Install autojump plugin
sudo cd $ZSH_CUSTOM/plugins/autojump; ./install.py

echo Configuration ohmyzsh environment
sudo wget https://raw.githubusercontent.com/xc-awesome/ohmyzsh-install/main/.zshrc-root -O ~/.zshrc

echo Source ~/.zshrc
sudo source ~/.zshrc
