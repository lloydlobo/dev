#!/usr/bin/env bash
#
# pomo.sh implements a Pomodoro timer - a productivity technique where you work
# in focused intervals (typically 25 minutes) followed by short breaks.
# After each timer, it waits for Enter to start the next session.
#
# Usage:
#
#     pomo 15 Take a break
#
# Run in the background:
#
#     pomo.sh 20 &
#     nohup pomo.sh 20 &
#     ps -ef | grep pomo
#     kill -9 [PID]
#

#
# WARN: This interface with (SIGKILL?) Ctrl-C
#
# NOTE: Setup trap to restore cursor on script's exit.
#
#       trap: Defines and activates handlers to be run when the shell receives
#             signals or other conditions.
#       EXIT: exit - cause normal process termination
#       TERM: term - format of compiled term file.
# trap 'printf "\033[?25h"' EXIT INT TERM
#

set -euo pipefail # Exit on error, undefined vars, pipe failures

# Cleanup function to restore terminal state
cleanup() {
	tput cnorm 2>/dev/null || true # Show cursor.
	tput sgr0 2>/dev/null || true  # Reset terminal attributes.
	exit 0
}

# Setup signal handlers
trap cleanup EXIT INT TERM # Show the terminal cursor

arg1=$1   # capture the first argument (timer duration in minutes)
shift     # remove the first argument, so $* contains the remaining arguments
args="$*" # combine all remaining arguments into the timer message

#
# NOTE: Syntax: ${variable:?error_message}
#       If variable is set and non-empty: use its value
#       If variable is unset or empty: print error and exit
#
readonly MIN=${arg1:?Usage: pomo <minutes> <message>}
readonly SEC=$((MIN * 60))
readonly MSG="${args:?Usage: pomo <minutes> <message>}"

# Validate input
if ! [[ "$MIN" =~ ^[0-9]+$ ]] || ((MIN <= 0)); then
	echo "ERROR: Duration must be a positive number" >&2
	exit 1
fi

#
# center_textln centers the text and prints it to the terminal with a newline.
#
#     `padding = (terminal_width - text_length) / 2`
#
center_textln() {
	local text="$1"
	local cols=$(tput cols) # Number of columns for the current terminal.
	local padding=$(((cols - ${#text}) / 2))
	printf "%*s%s\n" "$padding" "" "$text"
}

#
# center_text centers the text and prints it to the terminal without a newline.
#
#     `padding = (terminal_width - text_length) / 2`
#
center_text() {
	local text="$1"
	local cols=$(tput cols) # Number of columns for the current terminal.
	local padding=$(((cols - ${#text}) / 2))
	# NOTE: Removing linefeed charachter for more flexibility.
	#       printf "%*s%s\n" "$padding" "" "$text"
	printf "%*s%s" "$padding" "" "$text"
}

#
# \033[2K - Clear entire line
# \033[1K - Clear from cursor to beginning of line
# \033[0K - Clear from cursor to end of line
# \r - Return cursor to beginning of line
#
center_text_clear_line() {
	local text="$1"
	local cols=$(tput cols)
	local padding=$(((cols - ${#text}) / 2))
	printf "\033[2K\r%*s%s" "$padding" "" "$text"
}

show_progress() {
	# #1. Load
	local filled=$1
	local bar_length=$2
	local percent=$3
	local i=$4
	local sec=$5

	# #2. Build each part (cmp~combine)
	local filled_part=$(printf "%*s" "$filled" | tr ' ' '=')
	local empty_part=$(printf "%*s" $((bar_length - filled)) | tr ' ' '-')
	local time_part=$(
		printf "%d%% (%02d:%02d/%02d:%02d)" \
			"$percent" $((i / 60)) $((i % 60)) $((sec / 60)) $((sec % 60))
	)

	# #3. Combine
	local result="[${filled_part}${empty_part}] ${time_part}"

	printf "\r" # Start of bar (Carriage Return)
	center_text_clear_line "$result"
}

#
# Trigger non-blocking desktop notification.
#
# Usage: notify "Done!" "$MSG"
#
notify() {
	local message="$1"
	local title="${2:-Pomodoro}" # Set default title.

	if command -v zenity >/dev/null 2>&1; then #                               NOTE: Replace --notification as --info blocking prompt.
		zenity --notification --text="$title: $message" 2>/dev/null &
	elif command -v notify-send >/dev/null 2>&1; then #                        NOTE: Requires libnotify.
		notify-send -u critical -t 5000 "$title" "$message" 2>/dev/null &
	elif command -v osascript >/dev/null 2>&1; then #                          NOTE: macOS support
		osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null &
	fi
}

# If you want to clear everything and start fresh.
clear_and_center() {
	local text="$1"
	local cols=$(tput cols)
	local lines=$(tput lines)
	local padding=$(((cols - ${#text}) / 2))

	clear # Clear screen and position cursor in middle
	tput cup $((lines / 2)) "$padding"
	printf "%s" "$text"
}

function run_pomodoro() {
	notify "Starting ${MIN:?} min timer..." "$MSG"

	tput sgr0 2>/dev/null || true  # Reset all terminal text attributes:
	tput civis 2>/dev/null || true # Hide the terminal cursor

	# printf "\033[?25l"             # Hide cursor before starting progress updates (low visibility)
	# printf "\033[?25h"             # Show cursor when done (high visibility)

	while true; do
		center_text "${MIN} min timer: ${MSG}"
		echo # or use center_textln

		# Countdown loop.
		for ((i = 0; i <= SEC; i++)); do
			percent=$((i * 100 / SEC))
			bar_length=50
			filled=$((percent * bar_length / 100))
			show_progress "$filled" "$bar_length" "$percent" "$i" "$SEC"
			sleep 1
		done

		# Trigger terminal notification on completion.
		echo
		printf "\n\033[5;31m✓ %s\033[0m\n" "${MSG:?}" # Red flashing emoji+text
		echo -e "\a"                                  # System beep with \a (Enable interpretation of backslash escapes )

		# Trigger Desktop notification on completion.
		notify "Timer completed!" "$MSG"

		# Wait for user input.
		echo
		read -r -p "Press Enter to start next session (or Ctrl+C to quit)..."
		clear
	done

}

if ! command -v tput >/dev/null 2>&1; then
	echo "WARNING: tput not found, display may be limited" >&2
fi

run_pomodoro

#
# v1:
#
#     sleep "${sec:?}" && { echo "${msg:?}" && notify-send -u critical -t 0 "${msg:?}" }
#
# v2:
#
#     sleep "${sec:?}" && {
#     	echo "$(date): ${msg:?}"
#     		# Flash the terminal and beep
#     		for ((i = 1; i < 6; i++)); do
#     			tput rev; echo "${msg:?}"; sleep 0.3
#     			tput sgr0; sleep 0.2
#     			echo -e "\a"
#     		done
#     	}
#
# References:
#
# - https://www.reddit.com/r/commandline/comments/nqf8an/probably_the_simplest_pomodoro_timer_cli_for_linux/
#

#
# See `:h modeline`.
#
# vim:filetype=bash
# vim:fileencoding=utf-8
##FIXME: bash requires tabs.. What is the correct syntax?
# #vim:#ts=4 sts=4 sw=4 et
#
