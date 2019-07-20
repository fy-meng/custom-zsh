# acquire default username
while true; do
  echo "Is <$(logname)> your default user? [Y/n]"
  read response
  if [[ "$response" == "" || "$response" =~ [yY]([eE][sS])? ]]; then
    default_user=$(logname)
    break
  elif [[ "$response" =~ [nN][oO]? ]]; then 
    echo "Please enter your default user:"
    read default_user
    break
  fi
done

# install brew
if [[ ! -n $(which brew) ]]; then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.zshhubusercontent.com/Homebrew/install/master/install)"
fi

# install dependencies:
for dep in curl git python zsh; do
  if [[ ! -n $(which $dep) ]]; then
    echo "Installing $dep..."
    brew install $dep
  fi
done

# set zsh as the default shell
if [[ $SHELL != $(which zsh) ]]; then
  chsh -s $(which zsh)
fi

# install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
fi

# install zsh plugins
if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi 
if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting ]]; then
  echo "Installing fast-syntax-highlighting..."
  git clone https://github.com/zdharma/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
fi
if [[ ! -n $(which autojump) ]]; then
  echo "Installing autojump..."
  brew install autojump
fi

# install font: Menlo for Powerline
if [[ ! -f ~/Library/Fonts/Menlo\ for\ Powerline.ttf ]]; then
  echo "Downloading Menlo for Powerline..."
  git clone https://github.com/abertsch/Menlo-for-Powerline.git
  mv Menlo-for-Powerline/* ~/Library/Fonts
  rm -rf Menlo-for-Powerline
fi

# modify .zshrc
python add_plugins.py
if [[ ! -n $(sed -ne "s/export DEFAULT_USER=\(.*\)/\1/p" ~/.zshrc) && -n $default_user ]]; then
  echo "\n# default user to hide agnoster prompt\nexport DEFAULT_USER=$default_user\n" >> ~/.zshrc
fi
