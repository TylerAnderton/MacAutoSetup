# Only run in interactive shells
[[ $- != *i* ]] && return

# Ensure vi mode is on
bindkey -v

# --- Yank to macOS clipboard ---
function vi-yank-clipboard() {
  zle .vi-yank || return
  print -rn -- "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard
bindkey -M visual 'y' vi-yank-clipboard

# --- Paste from macOS clipboard with P / p ---
function vi-put-clipboard-before() {
  CUTBUFFER=$(pbpaste)
  zle .vi-put-before
}
zle -N vi-put-clipboard-before
bindkey -M vicmd 'P' vi-put-clipboard-before
bindkey -M visual 'P' vi-put-clipboard-before

function vi-put-clipboard-after() {
  CUTBUFFER=$(pbpaste)
  zle .vi-put-after
}
zle -N vi-put-clipboard-after
bindkey -M vicmd 'p' vi-put-clipboard-after
bindkey -M visual 'p' vi-put-clipboard-after
