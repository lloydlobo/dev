#!/usr/bin/env bash
# Usage:
#
#	DEV_ENV=~/Personal/dev ./dev-env.sh --dry
dry_run="0";

if [[ -z "$XDG_CONFIG_HOME" ]]; then
	echo "no xdg config home";
	echo "using ~/.config";
	XDG_CONFIG_HOME=$HOME/.config;
fi

if [[ -z "$DEV_ENV" ]]; then
    echo "error: the environment variable DEV_ENV is not set";
    echo "please set DEV_ENV to the path of your development environment";
	exit 1;
fi

if [[ $1 == "--dry" ]]; then
	dry_run="1";
fi

log() {
	if [[ $dry_run == "1" ]]; then
		echo "[DRY_RUN]: $1";
	else
		echo "$1";
	fi
}

log "env: $(realpath $DEV_ENV)";

update_files() {
	log "copying over files from: $1";

	if [[ ! -d "$1" ]]; then
		log "error: source directory $1 does not exist";
		return 1;
	fi

	pushd $1 &> /dev/null;
	(
		local configs=$(find . -mindepth 1 -maxdepth 1 -type d);
		if [[ -z "$configs" ]]; then
			log "info: no directories found in $1";
		fi

		for c in $configs; do
			local directory=${2%/}/${c#./};

			log "    removing dir: trash $directory";
			if [[ $dry_run == "0" ]]; then
				remove $directory;
			fi

			log "    copying env: cp $c $2";
			if [[ $dry_run == "0" ]]; then
				cp -r ./$c $2;
			fi
		done
	)
	popd &> /dev/null;
}

copy() {
	log "removing: $2";
	if [[ $dry_run == "0" ]]; then
		remove $2;
	fi

	if [[ ! -e "$1" ]]; then
		log "error: source $1 does not exist!";
		return 1;
	fi

	log "copying: $1 to $2";
	if [[ $dry_run == "0" ]]; then
		cp $1 $2;
	fi
}

remove() {
    if command -v trash &> /dev/null; then
        trash $1;
    else
        echo "[WARNING]: 'trash' command not found. Falling back to 'rm'.";
        rm -rf $1;
    fi
}

update_files $DEV_ENV/env/.config $XDG_CONFIG_HOME;
update_files $DEV_ENV/env/.local $HOME/.local;

# copy $DEV_ENV/tmux-sessionizer/tmux-sessionizer.sh $HOME/.local/scripts/tmux-sessionizer.sh;
copy $DEV_ENV/env/.zsh_profile $HOME/.zsh_profile;
copy $DEV_ENV/env/.zshrc $HOME/.zshrc;
# copy $DEV_ENV/env/.xprofile $HOME/.xprofile;
# copy $DEV_ENV/env/.tmux-sessionizer/ $HOME/.tmux-sessionizer/; # => git module
# copy $DEV_ENV/dev-env $HOME/.local/scripts/dev-env;
