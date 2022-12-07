# # start ssh-agent if necessary
ssh_agent_config="${HOME}/.ssh/agent.config"
function sssh {
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
