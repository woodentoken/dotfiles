#~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

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

# # start ssh-agent if necessary
ssh_agent_config="${HOME}/.ssh/agent.config"

sssh(){
  touch "$ssh_agent_config"
  chmod 600 "$ssh_agent_config"
  /usr/bin/ssh-agent | sed 's/^echo/#echo/g' > "$ssh_agent_config"
  . "$ssh_agent_config"
  for key in $(find ~/.ssh/ -maxdepth 1 -name '*id_ed25519' -o -name '*id_rsa' -o -name '*_private'); do  
    echo "$key"
    /usr/bin/ssh-add "$key"
  done
}

# this forces the ssh start on login:
# if [ -f "$ssh_agent_config" ]; then
#   . "$ssh_agent_config"
#   agent_proc=$(ps -p $SSH_AGENT_PID | grep ssh-agent)
#   if [ -z "$agent_proc" ]; then
#     sssh
#   fi
# else
#   sssh
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
