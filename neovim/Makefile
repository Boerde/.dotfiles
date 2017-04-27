CONFIG_PATH=~/.config/nvim

install: plugins-install
	mkdir -p $(CONFIG_PATH)
	rm $(CONFIG_PATH)/init.vim
	# link vim config
	ln -sv ~/.dotfiles/neovim/init.vim $(CONFIG_PATH)
	# link spell file
	ln -sv ~/.dotfiles/neovim/spell $(CONFIG_PATH)

plugins-install:
	rm ~/.local/share/nvim/site/autoload/plug.vim
	ln -sv ~/.dotfiles/neovim/plugins/vim-plug/plug.vim ~/.local/share/nvim/site/autoload
