#!/usr/bin/env bash

# Source https://gist.github.com/nikhita/432436d570b89cab172dcf2894465753?permalink_comment_id=5198767#gistcomment-5198767

version=$(go version 2>/dev/null || echo "none")
release=$(wget -qO- "https://golang.org/VERSION?m=text" | awk '/^go/{print $0}')

if [[ $version == *"$release"* ]]; then
	echo "The local Go version ${release} is up-to-date."
	exit 0
else
	echo "The local Go version is ${version}. A new release ${release} is available."
fi

release_file="${release}.linux-amd64.tar.gz"

tmp=$(mktemp -d)
cd "$tmp" || exit 1

echo "Downloading https://go.dev/dl/$release_file ..."
curl -OL https://go.dev/dl/"$release_file"

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$release_file"

rm -rf "$tmp"

cd ~ || exit 1

current_shell=$(basename "$SHELL")
if [[ "$current_shell" == "fish" ]]; then
	set -x GOROOT /usr/local/go
	set -x PATH "$GOROOT"/bin "$PATH"
elif [[ "$current_shell" == "zsh" || "$current_shell" == "bash" ]]; then
	export GOROOT=/usr/local/go
	export PATH=$GOROOT/bin:$PATH
fi

version=$(go version)
if [[ $version == *"$release"* ]]; then
	echo "Now, local Go version is $version"
else
	echo "Failed to update Go. Current version is still $version."
	exit 1
fi
