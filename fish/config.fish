# PATH
set -x PATH /usr/local/bin $PATH
set -x GOPATH $HOME
set -x PATH $GOPATH/bin $PATH

# alias
alias ls "ls -aG"
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"
alias mkdir "mkdir -p"

## Git
alias gst "git status"
# alias gdif "git diff"
# alias gdifc "git diff --cached"

## navigation
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'


# user defined functions
function cd
  builtin cd $argv
  ls
end

## peco with option
function peco
  command peco --layout=bottom-up $argv
end

## peco でコマンド履歴を検索する
function peco_select_history
    if test (count $argv) = 0
        set peco_flags --layout=bottom-up
    else
        set peco_flags --layout=bottom-up --query "$argv"
    end
    history | peco $peco_flags | read foo
    if [ $foo ]
        commandline $foo
    else
        commandline ''
    end
end

## peco で ghq で管理するリポジトリを検索する
function peco_ghq_repository
  set selected_repository (ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_repository" ]
    cd $selected_repository
    echo " $selected_repository "
    commandline -f repaint
  end
end


# key bindings
function fish_user_key_bindings
  # C-r でコマンド履歴を peco 検索
  bind \cr peco_select_history
  # C-o で ghq で入れたリポジトリを検索して cd
  bind \co peco_ghq_repository
end