# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' max-errors 2
export PATH=$PATH

autoload -Uz compinit
compinit
#TODO: This should have a timeout.
# End of lines added by compinstall
unsetopt beep
#export ZHOSTNAME="`hostname -f`"
export ZHOSTNAME="$(
  { hostname -f 2>/dev/null || hostname -F 2>/dev/null || hostname 2>/dev/null || print -r -- "${HOST:-$HOSTNAME}"; } \
  | awk 'NF{print; exit}'
)"

export ZPROMPT="$"
export ZUSERNAME="`whoami`"
if [ $ZUSERNAME = "root" ]; then
  ZPROMPT="%{$fg[red]%}%#%{$reset_color%}"
fi

echo "$ZUSERNAME@$ZHOSTNAME `pwd`"

bindkey -v
export KEYTIMEOUT=1
function zle-line-init zle-keymap-select {
  RPS1="${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/[INSERT]}"
  RPS2=$RPS1
  PROMPT=$ZPROMPT
  if $ran_something; then
    ran_something=false
  fi
  zle reset-prompt
  zle -R
}

function preexec() {
  timer=${timer:-$SECONDS}
  ran_something=true
}

function precmd() {
  ZEXITONE=$?
  ZEXITSTR=$?
  timer_show=-1

  #show the timer.
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    unset timer
  fi

  #exit code string
  ZEXITLBL=""
  if [ $ZEXITONE != 0 ]; then
    ZEXITSTR="[\e[91m"$ZEXITONE"\e[39m]"
  #  ZEXITLBL="\e[91m\u274C\e[39m"
    ZEXITLBL="\e[91mNo\e[39m"
  else
    ZEXITSTR="[\e[32m"$ZEXITONE"\e[39m]"
  #  ZEXITLBL="\e[32m\u2714\e[39m"
    ZEXITLBL="\e[32mOk\e[39m"
  fi

  #username color
  ZUSERNAMESTR=$ZUSERNAME
  if [ $ZUSERNAME = "root" ]; then
    ZUSERNAMESTR="\e[91mroot\e[39m"
  elif [ $ZUSERNAME != "marino" ]; then
    ZUSERNAMESTR="\e[96m$ZUSERNAME\e[39m"
  fi

  #Git
#  ZGIT=false
#if git rev-parse --git-dir > /dev/null 2>&1; then
#  ZGIT=true
#  : # This is a valid git repository (but the current working
#    # directory may not be the top level.
#    # Check the output of the git rev-parse command if you care)
#else
#  : # this is not a git repository
#fi

# Raw header may include literal backslash escapes like \e[32m
prompt_header_raw=" ${timer_show}s ${ZEXITSTR} ${ZUSERNAMESTR}@${ZHOSTNAME} ${PWD}"

# Expand \e, \n, etc into real control characters
prompt_header_expanded=$(printf '%b' "$prompt_header_raw")

# Strip ANSI CSI sequences (now they are real ESC bytes)
setopt localoptions extendedglob
prompt_header_no_ansi=${prompt_header_expanded//$'\e'\[[0-9\;]##m/}

iprompt_header=${#prompt_header_no_ansi}

cols=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
fill=$(( cols - 3 - iprompt_header ))
(( fill < 0 )) && fill=0
drawline=${(l:$fill:: :)""}

# Print: %b interprets escapes in the underline + reset sequences too
printf '%b\n' "$prompt_header_expanded"$'\e[4m'"$drawline"$'\e[0m'

  #eternal history
  echo $$ $ZUSERNAME $ZHOSTNAME $ZEXITONE "$(history -i -1)" >> ~/.eternal_history
}

zle -N zle-line-init
zle -N zle-keymap-select
