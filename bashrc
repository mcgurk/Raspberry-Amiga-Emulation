if [[ `tty` == "/dev/tty1" ]] && [[ `grep -o noamiga /proc/cmdline` != "noamiga" ]]; then
  echo "TTY1 - Starting Amiberry"
  ~/startAmiberry
fi
