#!/bin/bash

# define var
ZSH_CUSTOM=~/.oh-my-zsh/custom
ZSHRC=~/.zshrc
AUTOJUMP_PATH="$ZSH_CUSTOM/plugins/autojump"

# print color
print() {
    echo "$@" | sed \
        -e "s/\(\(@\(red\|green\|yellow\|blue\|magenta\|cyan\|white\|reset\|b\|u\)\)\+\)[[]\{2\}\(.*\)[]]\{2\}/\1\4@reset/g" \
        -e "s/@red/$(tput setaf 1)/g" \
        -e "s/@green/$(tput setaf 2)/g" \
        -e "s/@yellow/$(tput setaf 3)/g" \
        -e "s/@blue/$(tput setaf 4)/g" \
        -e "s/@magenta/$(tput setaf 5)/g" \
        -e "s/@cyan/$(tput setaf 6)/g" \
        -e "s/@white/$(tput setaf 7)/g" \
        -e "s/@reset/$(tput sgr0)/g" \
        -e "s/@b/$(tput bold)/g" \
        -e "s/@u/$(tput sgr 0 1)/g"
}

# welcome
welcome() {
    printf '\033[1m \033[34m'
    cat <<-'EOF'

___  _ ____        ____  _     _____ _     _
\  \///   _\      / ___\/ \ /|/  __// \   / \
 \  / |  /  _____ |    \| |_|||  \  | |   | |
 /  \ |  \__\____\\___ || | |||  /_ | |_/\| |_/\
/__/\\\____/      \____/\_/ \|\____\\____/\____/
                                                    Start installing and configuring shell
EOF
    printf '\033[m'
}

install() {
    print @b@magentaYum install zsh ...@reset
    sudo yum install zsh -y

    print @b@magentaYum install git@reset
    sudo yum install git -y

    print @b@magentaYum install oh my zsh@reset
    sudo sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)" "" --unattended

    if [ -d "${ZSH_CUSTOM}" ]; then
        print @b@cyanGit clone oh my zsh plugin for zsh-autosuggestions@reset
        sudo git clone https://gitee.com/xs-mirrors/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

        print @b@cyanGit clone oh my zsh plugin for zsh-syntax-highlighting@reset
        sudo git clone https://gitee.com/xs-mirrors/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

        print @b@cyanGit clone oh my zsh plugin for autojump@reset
        sudo git clone https://gitee.com/xs-mirrors/autojump.git $ZSH_CUSTOM/plugins/autojump

        print @b@blueInstall autojump plugin@reset
        if [ -d "${AUTOJUMP_PATH}" ]; then
            cd "${AUTOJUMP_PATH}"
            ./install.py
        fi
    fi
}

reconfiguration() {
    print @b@greenreconfiguration@reset
    sed -i 's/# DISABLE_UPDATE_PROMPT="true"/DISABLE_UPDATE_PROMPT="true"/' ${ZSHRC}
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' ${ZSHRC}
    sed -i 's/plugins=(git)/plugins=(git iterm2 autojump zsh-autosuggestions zsh-syntax-highlighting)/' ${ZSHRC}

    if [ "${HOME}" == "/root" ]; then
        if ! grep -q "alias vi=\"vim\"" ${ZSHRC}; then
            echo 'alias vi="vim"' >>${ZSHRC}
        fi
    fi

    if ! grep -q "autojump.sh" ${ZSHRC}; then
        cat <<EOF >>${ZSHRC}
[[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source ${HOME}/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u
EOF
    fi

    cd ~/
    print @b@red"Please restart terminal(s) before running shell. Activation zsh shell."@reset
    chsh -s /bin/zsh
    exec zsh -l
}

main() {
    welcome
    install
    reconfiguration
}

main
