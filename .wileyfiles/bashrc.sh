#!/bin/bash

# add this to your .bashrc
#
#     test -f ~/.wileyfiles/bashrc.sh && source  ~/.wileyfiles/bashrc.sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

function _currGitBranch() {
  git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1}/'
}
color_green='\[\e[1;32m\]'
color_yellow='\[\e[1;33m\]'
color_reset='\[\e[0m\]'
export PS1="${color_green}[\u@\h \W${color_yellow}\$(_currGitBranch)${color_green}]\$${color_reset} "

stty -ctlecho

if [[ -d "$HOME/go" ]] ; then
  export GOPATH="$HOME/go"
fi

# Set up our path to include various additional directories
additional_path_components=(
  "/usr/local/sbin"
  "/usr/local/bin"
  "/usr/local/go/bin"
  "$GOPATH/bin"
  "$HOME/.local/bin"
)

for path_component in "${additional_path_components[@]}" ; do
  if [[ -d "$path_component" && "$PATH" != *"$path_component"* ]] ; then
    PATH="$path_component:$PATH"
  fi
done

NVIM_PACKER_PATH="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
VIM_BINARY=`which nvim`
if [[ ! -x "$VIM_BINARY" || ! -d "$NVIM_PACKER_PATH" ]] ; then
  if [[ ! -d "$NVIM_PACKER_PATH" ]] ; then
    echo Neovim package manager is not installed.  Try running:
    echo "  git clone --depth 1 https://github.com/wbthomason/packer.nvim $NVIM_PACKER_PATH"
  fi
  echo 'Using vim (rather than nvim) as our editor.'
  VIM_BINARY=`which vim`
else
  if [[ ! $(set -e; ls "${HOME}/.local/share/nvim/site/pack/packer/start" | grep -v packer.nvim) ]] ; then
    echo "Found Neovim and packer, but didn't find installed packages."
    echo "Open neovim, ignore that error, and run :PackerInstall"
  fi
fi
export EDITOR="$VIM_BINARY"

_memuseImpl() {
  /bin/ps -u $(whoami) -o pid,rss,command | awk '{sum+=$2} END {print "Total " sum / 1024 " MB"}';
}

_git_hall_of_fame_impl() {
git ls-files -z | xargs -0n1 git blame -w | ruby -n -e '$_ =~ /^.*?\((.*?)\s[\d]{4}/; puts $1.strip' | sort -f | uniq -c | sort -n
}

_untilFailImpl() {
  $@
  while [ $? -eq 0 ]; do
    $@
  done
}

# This is probably overridden in .corp_rc
WILEY_SNIPPETS_DIR=$HOME

_snippets_impl() {
	local snippets_file_prefix
  local file_list
  local args=$@
  if [[ "$#" -eq "0" ]] ; then
    args=0
  fi
  for num in $args ; do
    snippets_file_prefix=$("$HOME"/.wileyfiles/snippets.py $num)
    local ret=$?
    if [ $ret -ne 0 ] ; then
      echo "refusing to open snippets file script exited with status: $ret"
      return $ret
    fi
    file_list="$file_list ${WILEY_SNIPPETS_DIR}/${snippets_file_prefix}.md"
  done
  "$VIM_BINARY" -O $file_list
}

_snippets_push_impl() {
  if [[ ! -d "$WILEY_SNIPPETS_DIR/.git" ]] ; then
    echo "cannot push snippets, it doesn't look like a git repository?"
    return 1
  fi
  if [[ "$(cd $WILEY_SNIPPETS_DIR; git diff --stat)" == "" ]] ; then
    echo "cannot push snippets, there do not seem to be local changes?"
    return 1
  fi
  echo "Pushing snippet changes to git"
  pushd "$WILEY_SNIPPETS_DIR" 2>/dev/null
  git add *.md
  git commit -m "Snippets update $(date -I)"
  git push
  popd 2>/dev/null
}

# no one touches but me
umask 077

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CFG'
# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias vi="'$VIM_BINARY' -O"
alias vim="'$VIM_BINARY' -O"

alias gg='git grep'
alias ga='git commit --all --amend -C HEAD'
alias gb='git branch'
alias gc='git checkout'
alias gs='git status'
alias gss='git show --stat --oneline HEAD'
alias gr='git rev-parse --show-toplevel'
gnb() {
	git checkout -t origin/master -b wiley/$@
}
# Git hall of fame
alias git-hof=_git_hall_of_fame_impl
alias tm='tmux'
alias dps='docker ps --format "table {{ .Image }}\t{{ .Command }}\t{{ .Status }}\t{{ .Names}} "'
alias cpu-temps='cat /sys/class/thermal/thermal_zone*/temp'
alias mem=_memuseImpl

alias snippets=_snippets_impl
alias snippets_push=_snippets_push_impl

alias untilfail=_untilFailImpl

bash_extensions=(
  /usr/share/doc/fzf/examples/key-bindings.bash
  /usr/share/doc/fzf/examples/completion.bash
  # Probably we have installed via apt, but this is the default for manual install.
  "${HOME}/.fzf.bash"
  "${HOME}/.corp_rc"
)
for bash_extension in "${bash_extensions[@]}" ; do
	test -f "$bash_extension" && source "$bash_extension"
done

if command -v fzf >/dev/null && command -v rg >/dev/null ; then
  # fzf has some default behavior when you invoke it like `fzf` to
  # search the result of running `find .`.  Make this respect
  # .gitignore (and be super fast) by using rg.
  export FZF_DEFAULT_COMMAND="rg --files || rg -u --files"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  v() {
    if [[ "$#" != 0 ]] ; then
      "$VIM_BINARY" -O "$@"
    else
      "$VIM_BINARY" $(fzf)
    fi
  }
else
  echo "fzf enabled v command not enabled because fzf or rg is not installed."
  v() {
    "$VIM_BINARY"
  }
fi

function replace {
  local pattern="$1"
  local replacement="$2"
  rg "$pattern" | cut -d: -f1 | sort | uniq | xargs sed -i "s|$pattern|$replacement|g"
}


if [[ "$(uname)" == "Linux" ]] ; then
  alias tmcp='tmux show-buffer | xclip -selection clipboard'
  alias open='xdg-open'
  # Disable the caps lock keycode
  setxkbmap -option ctrl:nocaps
fi

if [[ "$(uname)" == "Darwin" ]] ; then
  alias tmcp='tmux show-buffer | pbcopy'
  # OSX has a builtin `open` command
  export BASH_SILENCE_DEPRECATION_WARNING=1
  BREW_BASH_COMPLETION=/usr/local/etc/bash_completion
  test -r $BREW_BASH_COMPLETION && source "$BREW_BASH_COMPLETION"
fi