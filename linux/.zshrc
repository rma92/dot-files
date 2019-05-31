# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' max-errors 2
export PATH=$PATH

autoload -Uz compinit
compinit
#TODO: This should have a timeout.
# End of lines added by compinstall
unsetopt beep
export ZHOSTNAME="`hostname -f`"
export ZPROMPT="$"
echo "$USER@$ZHOSTNAME `pwd`"

bindkey -v
export KEYTIMEOUT=1
function zle-line-init {
  RPS1="${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/[INSERT]}"
  RPS2=$RPS1
  PROMPT=$ZPROMPT
  zle reset-prompt
  zle -R
}
function zle-keymap-select {
  RPS1="${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/[INSERT]}"
  RPS2=$RPS1
  PROMPT=$ZPROMPT
  zle reset-prompt
  zle -R
}

function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    unset timer
    echo "${timer_show}s $USER@$ZHOSTNAME `pwd`"

    #eternal history
    echo $$ $ZHOSTNAME "$(history -i -1)" >> ~/.eternal_history
  fi
}

zle -N zle-line-init
zle -N zle-keymap-select
