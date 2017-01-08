.PHONY: run
run:
	convox start

.PHONY: test
test:
	convox start web rake
