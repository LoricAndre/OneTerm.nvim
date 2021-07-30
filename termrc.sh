fzf() {
  nvr --remote-send "<Esc>:e $(fzf $@)"
}

ranger() {
  /usr/bin/env ranger --choosefile=/tmp/oneterm $@
  nvr --remote-send "<Esc>"
  nvr "$(cat /tmp/oneterm)"
}
