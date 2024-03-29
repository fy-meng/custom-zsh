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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# install dependencies
for dep in curl git python; do
  if [[ ! -n $(which $dep) ]]; then
    echo "Installing $dep..."
    brew install $dep
  fi
done

# install zsh
if [[ $(which zsh) != $HOME/zsh ]]; then
  echo "Installing zsh..."
  brew install zsh
fi

# set zsh as the default shell
chsh -s $(which zsh)

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
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
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

# install trash
brew install trash

# modify .zshrc
python scripts/modify_zshrc.py $default_user

echo "Done"
