# kill ssh-agent on final logout (one pgrep instead of a ps|grep|grep|grep|wc pipeline)
if [ "$(pgrep -c -u "$USER" -f "tmux|$USER@")" -eq 1 ]; then
  test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k`
fi
