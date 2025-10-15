#!/usr/bin/env bash
# Ref: https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
#

# -e:          stop script on NZEC. 
# -u:          stop script if unbound variable found (use ${var:-} if intentional).
# -o pipefail: by default cmd1 | cmd2 returns exit code of cmd2 regardless of cmd1 success. this is causing it to fail.
set -euo pipefail 


# === Helpers ===

die () { 
    local msg="$1"
    echo "$msg" >&2; 
    exit 1;
}

# === Download ===

# $ DEV_ENV=~/Personal/dev ./run.sh dotnet --dry
# $ DEV_ENV=~/Personal/dev ./run.sh dotnet
if [[ ! -f "./dotnet-install.sh" ]]; then
    echo "Downloading dotnet-install.sh..."
    wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
    chmod +x dotnet-install.sh
fi

# === Setup ===

# Before running this script, make sure you grant permission for this script to run as an executable:
#     chmod +x $HOME/Personal/dev/runs/dotnet.sh

# The script defaults to installing the latest long term support (LTS) SDK
# version, which is .NET 8. 
mode="${1:-sdk}"

case "$mode" in 
    sdk)      ./dotnet-install.sh --version latest ;;
    runtime)  ./dotnet-install.sh --version latest --runtime dotnet ;; 
    aspnet)   ./dotnet-install.sh --version latest --runtime aspnetcore ;;  # .NET Runtime instead of the SDK
    channel)  ./dotnet-install.sh --channel "${2:-9.0}" ;;                  # you can install a specific major version with the --channel parameter to indicate the specific version.
    *)        die "Usage: $0 [sdk|runtime|aspnet|channel <version>]" ;;
esac

# # Dependencies
#
# The dotnet-install scripts are used for automation and non-admin installs of the SDK and Runtime. 
# You can download the script from https://dot.net/v1/dotnet-install.sh. 
# When .NET is installed in this way, you must install the dependencies required by your Linux distribution. 
# Use the links in the Install .NET on Linux article for your specific Linux distribution.
#
# ## DEB dependencies
#
# If your distribution wasn't previously listed, and is debian-based, you might
# need the following dependencies:
#
# - libc6
# - libgcc1
# - libgssapi-krb5-2
# - libicu70
# - libssl3
# - libstdc++6
# - zlib1g

# vim:filetype=zsh:
# vim:tw=78:ts=4:sw=4:et:ft=help:norl:
