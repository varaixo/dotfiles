# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc.

test -z "$PROFILEREAD" && . /etc/profile || true
test -z "$PROFILEREAD" && export PROFILEREAD=true
