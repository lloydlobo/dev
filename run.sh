#!/usr/bin/env bash
# Source: https://github.com/ThePrimeagen/dev/blob/master/run
#
# Usage:
#
#	DEV_ENV=~/Personal/dev ./run.sh --dry

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )";

if [[ -z "$DEV_ENV" ]]; then
	echo "error: the environment variable DEV_ENV is not set";
	echo "please set DEV_ENV to the path of your development environment";
	exit 1;
fi

# With DEV_ENV=$(pwd), ./run then this is needed for the rest of the scripts...
export DEV_ENV="$DEV_ENV";

grep="";
dry_run="0";

while [[ $# -gt 0 ]]; do
	echo "ARG: \"$1\"";

	if [[ "$1" == "--dry" ]]; then
		dry_run="1";
	else
		grep="$1";
	fi

	shift
done

log() {
	if [[ $dry_run == "1" ]]; then
		echo "[DRY_RUN]: $1";
	else
		echo "$1";
	fi
}

log "RUN: env: $env -- grep: $grep";

runs_dir=$(find $script_dir/runs -mindepth 1 -maxdepth 1 -executable);

for s in $runs_dir; do
	if echo "$s" | grep -vq "$grep"; then
		log "grep \"$grep\" filtered out $s";
		continue;
	fi

	log "running script: $s";

	if [[ $dry_run == "0" ]]; then
		$s;
	fi
done
