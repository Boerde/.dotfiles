install: install-neovim install-fzf

update: update-repo update-submodule update-fzf

update-repo:
	echo "Updating: Git Repo"
	git pull

update-submodule:
	echo "Updating: ALL git submodules"
	git submodule foreach git pull

install-neovim:
	echo "Installing: Neovim"
	make -C neovim install

install-bashrc:
	echo "Installing: Bashrc"
	rm -f ~/.bashrc
	ln -sv ~/.dotfiles/.bashrc ~/.bashrc

install-fzf:
	echo "Installing: fzf"
	./fzf/install

update-fzf:
	echo "Updating: fzf"
	./fzf/install
