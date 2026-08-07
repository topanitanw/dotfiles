.PHONY: install
install:
	bash scripts/install.sh

.PHONY: mac_setup
mac_setup:
	bash mac/setup/mac_setup.sh

.PHONY: clean
clean:
	find . -type f -iname "*.~undo-tree~" -delete
	find . -type f -iname "#*#" -delete
	find . -type f -iname "*~" -delete

.PHONY: view
view:
	tree -a --dirsfirst --noreport -I '.git'

.PHONY: format
format: format_bash

.PHONY: format_bash
format_bash:
	echo "Formatting bash scripts";
	sh_scripts=`find . -type f -name "*.sh" -not -path "./.git/*"`; \
	for file in $$sh_scripts; do \
		echo "Formatting $$file"; \
		shfmt -w -s -i 4 -ci $$file; \
	done
	echo
