#~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export SHELL=/usr/bin/zsh

# include generic profile aliases
if [ -f "$HOME/.profile.aliases" ]; then
  . "$HOME/.profile.aliases"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

export VISUAL=vim
export EDITOR="$VISUAL"

# SSH Specifics
SSH_ENV="$HOME/.ssh/agent-environment"
SSH_HOME="$HOME/.ssh/"

start_agent() {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add $SSH_HOME/*_id_rsa 1>&- 2>&-
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  echo "SSH_AGENT_PID: ${SSH_AGENT_PID} found - reusing existing agent."
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  echo "No SSH_AGENT_PID found - starting new agent."
  start_agent;
fi

. "$HOME/.cargo/env"
