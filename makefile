install:
	bash scripts/install.sh
.PHONY: install

mac_setup:
	bash mac/setup/mac_setup.sh
.PHONY: mac_setup

clean:
	find . -type f -iname "*.~undo-tree~" -delete
	find . -type f -iname "#*#" -delete
.PHONY: clean

view:
	tree -a --dirsfirst --noreport -I '.git'
.PHONY: view
