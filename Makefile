build:
	@docker build -t dotfiles-test-user .
test-user:
	@docker run --rm -it -v ${PWD}:/home/alberto/.dotfiles --name dotfiles-test-user --hostname dotfiles-test-user dotfiles-test-user
test-root:
	@docker run --rm -it -v ${PWD}:/root/.dotfiles --name dotfiles-test-root --hostname dotfiles-test-root ubuntu:jammy
test-user-curl:
	@docker run --rm -it --name dotfiles-test-user-curl --hostname dotfiles-test-user-curl dotfiles-test-user
modX:
	@chmod +x ./scripts/*.sh
