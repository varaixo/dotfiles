# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Special configuration for Google Cloud Shell environment.
if [ -d "/google" ] && [ -e "/.dockerenv" ]; then
	if [ -f "/google/devshell/bashrc.google" ]; then
		source /google/devshell/bashrc.google
	fi

	# Delete unneeded files.
	rm -f "${HOME:?}/README-cloudshell.txt"
fi

# Strict umask for privacy.
umask 0077

# On serial console we need to be sure whether console size is matching
# the size of a terminal screen.
if [[ "$(tty)" == /dev/ttyS* ]]; then
	PS0='$(eval "$(resize)")'

	if [ "$SHLVL" = "1" ]; then
		eval "$(resize)"
		printf '\033[!p'
	fi
fi

# Dynamically updated shell prompt.
_update_bash_prompt() {
	# Don't update prompt for Google Cloud Shell.
	if [ -d "/google" ] && [ -e "/.dockerenv" ]; then
		return
	fi

	# Add user@host prefix when connected over SSH.
	local user_host
	if [ -n "$SSH_CLIENT" ] && [ -z "$PROMPT_DISABLE_USERHOST" ]; then
		user_host="\\[\\e[1;35m\\]\\u\\[\\e[1;34m\\]@\\[\\e[1;35m\\]\\h\\[\\e[0m\\] "
	else
		user_host=""
	fi

	# Add Git branch information.
	local git_branch=""
	if [ -n "$(command -v git)" ]; then
		git_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\\[\\e[0;33m\\](\1)\\[\\e[0m\\] /')
	fi

	local py_virtualenv=""
	if [ -n "$VIRTUAL_ENV" ]; then
		py_virtualenv="\\[\\e[0;90m\\]($(basename "$VIRTUAL_ENV"))\\[\\e[0m\\] "
	fi

	# Finally build the PS1 prompt.
	PS1="${py_virtualenv}${user_host}\\[\\e[0;32m\\]\\w\\[\\e[0m\\] ${git_branch}\\[\\e[0;97m\\]\\$\\[\\e[0m\\] "

	# Set title for Xterm-compatible terminals.
	if [[ "$TERM" =~ ^(xterm|rxvt) ]]; then
		PS1="\\[\\e]0;\\u@\\h: \\w\\a\\]${PS1}"
	fi
}
PROMPT_COMMAND="_update_bash_prompt;"

# Show 2 directories of CWD context.
PROMPT_DIRTRIM=2

# Secondary prompt configuration.
PS2='> '
PS3='> '
PS4='+ '

# Shell options.
shopt -s autocd
shopt -s checkwinsize
shopt -s cmdhist
shopt -s globstar
shopt -s histappend
shopt -s histverify

# Configure bash history.
HISTSIZE=5000
HISTFILESIZE=1000000
HISTCONTROL="ignoreboth"
HISTTIMEFORMAT="%Y/%m/%d %T : "

# Specify default text editor.
EDITOR=$(command -v nvim)
if [ -z "$EDITOR" ]; then
	EDITOR=vim
fi
export EDITOR

# Colorful output of GCC.
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Colorful output of ls.
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.cfg=00;32:*.conf=00;32:*.diff=00;32:*.doc=00;32:*.ini=00;32:*.log=00;32:*.patch=00;32:*.pdf=00;32:*.ps=00;32:*.tex=00;32:*.txt=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*.desktop=01;35:'

# Specify default pager.
export PAGER="less"

# For gpg in terminal.
export GPG_TTY=$(tty)

# Make less more friendly for non-text input files, see lesspipe(1).
if [ -x "$(command -v lesspipe)" ]; then
	eval "$(SHELL=$(command -v sh) lesspipe)"
fi

# Load script with shell aliases configuration.
if [ -f "${HOME}/.shell_aliases" ]; then
	. "${HOME}"/.shell_aliases
fi

# Enable programmable completion features.
if ! shopt -oq posix; then
	if [ -f "/usr/share/bash-completion/bash_completion" ]; then
		BASH_COMPLETION_FILE="/usr/share/bash-completion/bash_completion"
	elif [ -f "/etc/bash_completion" ]; then
		BASH_COMPLETION_FILE="/etc/bash_completion"
	else
		BASH_COMPLETION_FILE=""
	fi

	if [ -n "$BASH_COMPLETION_FILE" ]; then
		. "$BASH_COMPLETION_FILE"
		# The next line enables shell command completion for gcloud.
		if [ -f "${HOME}/.local/opt/google-cloud-sdk/completion.bash.inc" ]; then
			. "${HOME}/.local/opt/google-cloud-sdk/completion.bash.inc"
		else
			if [ -f "/opt/google-cloud-sdk/completion.bash.inc" ]; then
				. "/opt/google-cloud-sdk/completion.bash.inc"
			fi
		fi
	fi

	unset BASH_COMPLETION_FILE
fi

# Don't load custom ssh-agent startup script on laptop.
if [ ! -e "/sys/class/power_supply/BAT0" ]; then
	if [ -f "${HOME}/.ssh/setup-agent.sh" ]; then
		source "${HOME}/.ssh/setup-agent.sh"
	fi
fi

# Enable direnv support if possible.
# (direnv loads environment variables from .envrc files)
if [ -n "$(command -v direnv)" ]; then
	export DIRENV_LOG_FORMAT=
	eval "$(direnv hook bash)"
fi

# Google Cloud Shell specific: wait until environment is configured.
if [ -d "/google" ] && [ -e "/.dockerenv" ]; then
	if [ ! -e "/google/devshell/customize_environment_done" ]; then
		printf "Setting up the Cloud Shell environment."
		while [ ! -e "/google/devshell/customize_environment_done" ]; do
			printf "."
			sleep 1
		done
		echo "."
	fi
fi
