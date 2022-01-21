### These are the steps taken to create this image. See files in ~/starting_files, which are referenced below
### Start with Ubuntu fresh install (21.10 x64) (probably has custom changes that Vultr made)

# ** wait for apt install and apt upgrade (auto runs on first boot)

sudo apt install golang-go

# ** gives a warning that you might want to do a reboot

sudo reboot

# ** wait for reboot

curl -L https://github.com/neovim/neovim/releases/download/v0.6.1/nvim.appimage -o nvim
chmod u+x nvim
mv nvim /usr/bin
curl -sL install-node.vercel.app/lts | bash
alias vim=nvim

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" set vim init file
mkdir -p  ~/.config/nvim
mv ~/starting_files/init.vim ~/.config/nvim/init.vim 

export GOBIN=$HOME/go/bin                  
export PATH=$PATH:$GOBIN

vim +PlugInstall
vim +GoInstallBinaries
vim +CocInstall coc-json

vim
#### ** inside vim:
#	:CocConfig
#		save with the following:
#			{
#  				"languageserver": {
#   					"golang": {
#      				"command": "gopls",
#      				"rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
#      				"filetypes": ["go"]
#    					}
#				}
# 			}

export GIT_TERMINAL_PROMPT=1
mkdir -p ~/go/src/github.com/ert485
cd ~/go/src/github.com/ert485
git config --global credential.helper store
git clone https://github.com/ert485/capture && cd capture && git checkout cleanup

## ** enter username + github personal access token

go mod vendor
vim internal/device/example/main.go 

# ** check that gd (go to definition) works

" update bash init file
cat ~/.starting_files/.bashrc > ~/.bashrc
