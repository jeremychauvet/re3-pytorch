.PHONY: build test
.DEFAULT: build

build:
	docker build -t eks-nvidia:demo .

test:
	docker run --rm -it eks-nvidia:demo
