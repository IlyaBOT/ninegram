.PHONY: debug release test lint install

debug:
	bash ./Scripts/build-debug.sh

release:
	bash ./Scripts/build-release.sh

test:
	bash ./Scripts/run-tests.sh

lint:
	bash ./Scripts/lint.sh

install:
	bash ./Scripts/install-device.sh
