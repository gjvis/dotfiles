if [ -f $HOME/.rvm/bin/rvm ]; then
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

if [ -d /usr/local/lib/node_modules ]; then
  export NODE_PATH=/usr/local/lib/node_modules
  PATH=$PATH:/usr/local/share/npm/bin
fi

if [ -x "$(which brew)" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export HISTCONTROL=ignoredups

if [ "$TERM" != "dumb" ]; then
    if [ `uname` == "Darwin" ]; then
       alias ls='ls -G'
    else
       # eval "`dircolors -b`"
       alias ls='ls --color=auto'
    fi
fi

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOUR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="# Your branch is ([^ ]*)"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="^# On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  else
    branch="${LIGHT_GRAY}detached HEAD${state}"
  fi

  # Set the final branch string.
  BRANCH="${state}(${branch})${remote}${COLOUR_NONE} "
}

function setup_prompt {
  # Setup the BRANCH variable
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi

  # This runs before the prompt and sets the title of the xterm* window.  If you set the title in the prompt
  # weird wrapping errors occur on some systems, so this method is superior
  echo -ne "\033]0;${USER}@${HOSTNAME%%.*}"
  echo -ne "\007"

  PS1="${LIGHT_GRAY}[${HOSTNAME}] ${BLUE}\w${COLOUR_NONE} ${BRANCH}> "
}

export PROMPT_COMMAND=setup_prompt

export PS1="${LIGHT_GRAY}[${HOSTNAME}] ${BLUE}\w${COLOUR_NONE} ${BRANCH}> "  # Primary prompt with only a path
export PS2='> '    # Secondary prompt
export PS3='#? '   # Prompt 3
export PS4='+'     # Prompt 4

alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias ll='ls -hlF'
alias l='ls -lahF'

alias s2='subl2'
alias s='subl'
alias s.='s .'
alias webserver='python -m SimpleHTTPServer'

export EDITOR='subl -w'

alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pgstop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

if [ -f $HOME/.rvm/bin/rvm ]; then
  # This MUST be last for RVM to function correctly
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi
