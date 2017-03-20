install: install-neovim install-fzf

install-neovim:
	echo "Installing: Neovim"
	make -C neovim install

install-fzf:
	echo "Installing: fzf"
	./fzf/install
