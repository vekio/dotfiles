# wsl

## Manage Distributions

### Install Ubuntu
1. Download image from https://cloud-images.ubuntu.com/releases/
    File name must has `amd64-wsl` and the file type is `.tar.gz`.
2. Install execute the command.
    `wsl --import <DistributionName> <InstallLocation> <InstallTarFile>`
3. Add new user.
    `adduser <username>`
4. Give sudo access to new user.
    `usermod -aG sudo <username>`
5. Config default user.
    `vi /etc/wsl.conf`
    ```txt
    [user]
    default=<username>
    ```

### Remove distribution
Unregister would remove the distribution from the distributions available in WSL.
`wsl --unregister <DistributionName>`

### Shutdown WSL
Shutdown the WSL VM.
`wsl --shutdown`

## Font
- [Cascadia Font](https://github.com/microsoft/cascadia-code)

- Cascadia Code: standard version of Cascadia
- Cascadia Mono: a version of Cascadia that doesn't have ligatures
- Cascadia (Code|Mono) PL: a version of Cascadia that has embedded Powerline symbols

Download last realease and install the `ttf variable` version of 'Cascadia Code PL' and 'Cascadia Mono PL' for windows.

Using 'Cascadia Mono PL' in windows terminal and 'Cascadia Code' in VSCode.

## Profile
```json
// profile
{
    "acrylicOpacity": 0.7,
    "bellStyle": "visual",
    "colorScheme": "Campbell",
    "cursorShape": "filledBox",
    "fontFace": "Cascadia Mono PL",
    "fontSize": 12,
    "hidden": false,
    "scrollbarState": "hidden",
    "suppressApplicationTitle": true,
    "useAcrylic": true
}
```
