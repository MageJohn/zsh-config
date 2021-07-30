declare -A ZINIT
export ZINIT[HOME_DIR]="$HOME/Library/Zinit"
### Added by Zinit's installer
if [[ ! -f $ZINIT[HOME_DIR]/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$ZINIT[HOME_DIR]" && command chmod g-rwX "$ZINIT[HOME_DIR]"
    command git clone https://github.com/zdharma/zinit "$ZINIT[HOME_DIR]/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$ZINIT[HOME_DIR]/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

## Homebrew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

## Zinit annexes
zinit light-mode for \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-patch-dl

## ZSH-z
export ZSHZ_OWNER=yuripieters
export ZSHZ_DATA="$ZDOTDIR/.z"
zinit wait lucid for agkozak/zsh-z

## ls
export EXA_COLORS="da=38;5;214"
zinit wait pack"no-dir-color-swap" for ls_colors
alias ls="exa"

zstyle ':completion:*' menu select

## Prompt and keybindings
# apply substitution to the prompt
setopt promptsubst
# this function outputs the variable name, not it's value, and since
# promptsubst is on the value will be substituted when the prompt is rendered.
# the vim plugin then ensures the prompt is re-rendered.
function show_vim_mode() { echo '$MODE_INDICATOR_PROMPT' }

zinit load geometry-zsh/geometry

GEOMETRY_PROMPT=(geometry_echo geometry_status geometry_path show_vim_mode)
GEOMETRY_RPROMPT=(geometry_exec_time geometry_exitcode geometry_git geometry_hg geometry_echo)

# ansi is a function from geometry
MODE_INDICATOR_VIINS=$(ansi 10 '>>')
MODE_INDICATOR_VICMD=$(ansi 9 '<<')
MODE_INDICATOR_REPLACE=$(ansi 11 '>>')
MODE_INDICATOR_SEARCH=$(ansi 12 '<<')
MODE_INDICATOR_VISUAL=$(ansi 14 '<<')
MODE_INDICATOR_VLINE=$(ansi 8 '<<')

MODE_CURSOR_VIINS="block"
MODE_CURSOR_VICMD="underline"

setopt autocd


zinit wait lucid for \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

## vim bindings
zinit wait lucid for softmoth/zsh-vim-mode

## FZF
zinit wait pack"bgn-binary+keys" for fzf

## iTerm integration
source "$ZDOTDIR/.iterm2_shell_integration.zsh"

## fnm
eval "$(fnm env)"

## Git
alias g=git
