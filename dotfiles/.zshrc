# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM=/usr/share/zsh
ZSH_THEME="muse"
source $ZSH/oh-my-zsh.sh

# User configuration
alias v="nvim"
alias fzfp='fzf --preview="bat --theme=gruvbox-dark --color=always {}"'
alias fzfv='nvim $(fzf --preview="bat --theme=gruvbox-dark --color=always {}")'
alias fzfcd='cd "$(fd --type d --hidden --exclude .git | fzf --preview="tree -C {} | head -100")"'

# Plugins
plugins=(fzf git sudo)
export LANG=en_US.UTF-8
eval "$(zoxide init zsh)"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
