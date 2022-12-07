# kill ssh-agent on final logout
if [ $(ps -ef | grep $USER | grep -E "tmux|$USER@" | grep -v grep | wc -l) -eq 1 ]; then
  test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`
fi
