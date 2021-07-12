# wsl

## Install Ubuntu
1. Download image from https://cloud-images.ubuntu.com/releases/
    File name must has `amd64-wsl` and the file type is `.tar.gz`.
2. Install execute the command
    `wsl --import <DistributionName> <InstallLocation> <InstallTarFile>`
3. Add user
    `adduser xxxx`
4. Give sudo access to new user
    `usermod -aG sudo xxxx`
5. Config default user and default directoy.
    `vi /etc/wsl.conf`
    ```txt
    [user]
    default=username
    ```

## Remove distribution
Unregister would remove the distribution from the distributions available in WSL.
`wsl --unregister <DistributionName>`

## Shutdown wsl
Shut down the WSL 2 VM
`wsl --shutdown`
