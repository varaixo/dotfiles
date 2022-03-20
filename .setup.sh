#!/bin/sh
set -e

SCRIPT_DIR=$(dirname "$(realpath "$0")")

if [ ! -d "${SCRIPT_DIR}/.git" ]; then
	if [ "$SCRIPT_DIR" = "$HOME" ]; then
		echo "Already installed."
		exit 0
	else
		echo "Not a Git repository. Cannot bootstrap \$HOME."
		exit 1
	fi
fi

echo -n "This will overwrite configuration files in \$HOME. Do you want to continue? (y/n): "
read -r CHOICE
if [ "$CHOICE" != "y" ] && [ "$CHOICE" != "Y" ]; then
	echo "Aborting bootstrap."
	exit 1
fi

git --git-dir "${SCRIPT_DIR}/.git" --work-tree "$HOME" checkout -- "$HOME"
