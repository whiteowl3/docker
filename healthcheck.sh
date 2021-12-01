#This finds the internal DNS IP and attempts to ping it.
ping -i 10 -c 1 $(grep -Eo "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" /etc/resolv.conf) || bash -c 'kill -s 9 -1'
# The following is probably a more sane way to do it, if we aren't in a hurry to restart
# bash -c 'kill -s 15 -1 && (sleep 10; kill -s 9 -1)'
