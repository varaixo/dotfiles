# ~/.bash_profile: executed by the command interpreter for login shells.

# Strict umask for privacy.
umask 0077

# Ensure that cache directory exists.
if [ ! -d "${HOME}/.cache" ]; then
	mkdir -p "${HOME}/.cache"
	chmod 700 "${HOME}/.cache"
fi

# PATH: setup binary search paths including user's private directories.
export PATH="${HOME}/.local/bin:${PATH}"

# MANPATH: setup manual pages search paths including user's private
# directories.
export MANPATH="${HOME}/.local/share/man:/usr/local/share/man:/usr/share/man"

# GOPATH: directory where Golang will store modules.
export GOPATH="${HOME}/.cache/gopath"

# COLORTERM: indicate whether terminal supports TrueColor.
if [[ $TERM =~ .*-256color$ ]]; then
	export COLORTERM="truecolor"
fi

# AWS CLI.
if [ -d "${HOME}/.local/opt/aws-cli/bin" ]; then
	export PATH="${PATH}:${HOME}/.local/opt/aws-cli/bin"
else
	if [ -d "/opt/aws-cli/bin" ]; then
		export PATH="${PATH}:/opt/aws-cli/bin"
	fi
fi

# Google Cloud SDK.
if [ -d "${HOME}/.local/opt/google-cloud-sdk/bin" ]; then
	. "${HOME}/.local/opt/google-cloud-sdk/path.bash.inc"
else
	if [ -d "/opt/google-cloud-sdk/bin" ]; then
		. /opt/google-cloud-sdk/path.bash.inc
	fi
fi

# Special configuration for Google Cloud Shell environment.
if [ -d "/google" ] && [ -e "/.dockerenv" ]; then
	# For Android SDK.
	export ANDROID_HOME="/tmp/android-sdk"

	# Move Gradle temporary directory to /tmp, so it won't store data in
	# user home directory.
	export GRADLE_USER_HOME=/tmp/gradle-temp

	# For graphics over X/VNC.
	export DISPLAY=":1"
fi

# Finally, load ~/.bashrc.
[ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
