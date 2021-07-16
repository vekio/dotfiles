#!/usr/bin/env bash

mkdir -p ~/.ssh && chmod 700 ~/.ssh

chmod 600 .ssh/* && chmod 644 .ssh/*.pub

touch ~/.ssh/config && chmod 600 ~/.ssh/config

touch ~/.ssh/known_hosts && chmod 644 ~/.ssh/known_hosts
