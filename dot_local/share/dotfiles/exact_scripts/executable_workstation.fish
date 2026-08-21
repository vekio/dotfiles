#!/usr/bin/env fish

function info
    printf '\033[1;34m==>\033[0m %s\n' "$argv"
end

function die
    printf '\033[1;31mERROR\033[0m %s\n' "$argv" >&2
    exit 1
end

function usage
    printf '%s\n' \
        'Usage: workstation <command>' \
        '' \
        'Commands:' \
        '  apply                 Apply dotfiles and install missing software' \
        '  update                Update DNF, Flatpak and mise software' \
        '  pkg dnf|flatpak|mise  Add software to the managed package lists'
end

function require_commands
    for command in $argv
        command -q "$command"; or die "Required command not found: $command"
    end
end

function os_id
    test -r /etc/os-release; or die 'Missing /etc/os-release'

    while read -l line
        set -l field (string split -m 1 = -- "$line")

        if test "$field[1]" = ID
            string trim --chars "'\"" -- "$field[2]"
            return
        end
    end </etc/os-release

    die 'OS ID not found in /etc/os-release'
end

function package_file --argument-names source
    printf '%s/packages/%s/%s.txt\n' "$HOME/.local/share/dotfiles" (os_id) "$source"
end

function require_package_file --argument-names source
    set -l file (package_file "$source")
    test -f "$file"; or die "Package file not found: $file"
    printf '%s\n' "$file"
end

function select_packages --argument-names prompt preview
    fzf \
        --no-height \
        --multi \
        --layout=reverse \
        --border \
        --prompt="$prompt > " \
        --header='Tab: select · Enter: confirm · Esc: cancel' \
        --preview="$preview" \
        --preview-window='down:40%:wrap' \
        --bind='ctrl-k:preview-up,ctrl-j:preview-down'
end

function save_packages --argument-names file
    set -e argv[1]

    for package in $argv
        grep -qxF -- "$package" "$file"; or printf '%s\n' "$package" >>"$file"
    end

    sort -u -o "$file" "$file"
    chezmoi add "$file"; or return 1
    info "Updated $file"
end

function pkg_dnf
    test (os_id) = fedora; or die 'The DNF package source is only supported on Fedora'
    require_commands chezmoi dnf fzf grep sort

    set -l file (require_package_file dnf)
    set -l selected (
        dnf --cacheonly --quiet repoquery \
            --available \
            --latest-limit=1 \
            --queryformat '%{name}\n' |
        sort -u |
        select_packages 'Package' 'dnf --cacheonly --quiet info {1} 2>/dev/null'
    )

    test -n "$selected"; or return
    save_packages "$file" $selected
end

function pkg_flatpak
    require_commands chezmoi flatpak fzf grep sort

    set -l file (require_package_file flatpak)
    set -l selected (
        flatpak remote-ls flathub --app --columns=application |
        sort -u |
        select_packages 'Flatpak' 'flatpak remote-info flathub {1} 2>/dev/null'
    )

    test -n "$selected"; or return
    save_packages "$file" $selected
end

function pkg_mise
    require_commands awk chezmoi fzf mise sort

    set -l selected (
        mise registry |
        awk '{ print $1 }' |
        sort -u |
        select_packages 'Mise' 'mise tool {1} 2>/dev/null'
    )

    test -n "$selected"; or return

    for tool in $selected
        mise use --global "$tool@latest"; or return 1
    end

    chezmoi add "$HOME/.config/mise/config.toml"
end

function workstation_apply
    require_commands chezmoi

    info 'Applying dotfiles'
    chezmoi apply; or return 1

    set -l installer "$HOME/.local/bin/dotfiles-install"
    test -x "$installer"; or die "Installer not found: $installer"

    info 'Installing workstation software'
    "$installer"
end

function workstation_update
    switch (os_id)
        case fedora
            require_commands dnf sudo
            info 'Updating DNF packages'
            sudo dnf upgrade --refresh -y; or return 1
        case '*'
            die "Software updates are not supported on "(os_id)
    end

    if command -q flatpak
        info 'Updating Flatpak applications'
        flatpak update -y; or return 1
    end

    if command -q mise
        info 'Updating mise tools'
        mise upgrade; or return 1
    end

    printf '\033[1;32mOK\033[0m Workstation updated\n'
end

function workstation_pkg --argument-names source
    switch "$source"
        case dnf
            pkg_dnf
        case flatpak
            pkg_flatpak
        case mise
            pkg_mise
        case '*'
            printf 'Usage: workstation pkg {dnf|flatpak|mise}\n' >&2
            return 2
    end
end

function main
    switch "$argv[1]"
        case apply
            workstation_apply
        case update
            workstation_update
        case pkg
            workstation_pkg "$argv[2]"
        case '' -h --help
            usage
        case '*'
            printf 'Unknown command: %s\n\n' "$argv[1]" >&2
            usage >&2
            return 2
    end
end

main $argv
