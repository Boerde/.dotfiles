CONFIG_PATH=~/.config/nvim

install: plugins-install
	mkdir -p $(CONFIG_PATH)
	rm -f $(CONFIG_PATH)/init.vim
	# link vim config
	ln -sv ~/.dotfiles/neovim/init.vim $(CONFIG_PATH)
	# link spell file
	rm -f $(CONFIG_PATH)/spell
	ln -sv ~/.dotfiles/neovim/spell $(CONFIG_PATH)
	sudo pip3 install --upgrade neovim

plugins-install:
	rm -f ~/.local/share/nvim/site/autoload/plug.vim
	mkdir -p ~/.local/share/nvim/site/autoload
	ln -sv ~/.dotfiles/neovim/plugins/vim-plug/plug.vim ~/.local/share/nvim/site/autoload
