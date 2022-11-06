build:
	@docker build -q -t dotfiles-test-user .
test-user:
	@docker run --rm -it -v ${PWD}:/home/alberto/.dotfiles --name dotfiles-test-user --hostname dotfiles-test-user dotfiles-test-user
test-root:
	@docker run --rm -it -v ${PWD}:/root/.dotfiles --name dotfiles-test-root --hostname dotfiles-test-root ubuntu:jammy
