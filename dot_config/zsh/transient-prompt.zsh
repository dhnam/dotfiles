# Transient prompt (starship은 zsh에서 지원하지 않아서 직접 구현).
# 명령을 입력한 프롬프트가 바로 전 프롬프트와 같은 디렉터리면 `❯` 한 줄로 줄이고,
# 디렉터리가 바뀐 뒤 첫 프롬프트는 전체(위치, 시간, git 등)를 화면 기록에 남긴다.
# clink(cmd)의 prompt.transient = same_dir과 같은 규칙이다.

typeset -g _transient_prev_pwd
typeset -g _transient_prompt='%B%F{76}❯%f%b '

typeset -g _transient_saved_prompt _transient_saved_rprompt _transient_active

_transient_collapse() {
  if [[ -z $_transient_active && -n $_transient_prev_pwd && $PWD == $_transient_prev_pwd ]]; then
    _transient_saved_prompt=$PROMPT
    _transient_saved_rprompt=$RPROMPT
    _transient_active=1
    PROMPT=$_transient_prompt
    RPROMPT=
    zle .reset-prompt
  fi
  _transient_prev_pwd=$PWD
}

# 줄을 끝낼 때 마지막으로 한 번 더 그리므로, 원래 프롬프트는 다음 프롬프트 직전에 되돌린다
_transient_restore() {
  if [[ -n $_transient_active ]]; then
    PROMPT=$_transient_saved_prompt
    RPROMPT=$_transient_saved_rprompt
    _transient_active=
  fi
}

autoload -Uz add-zle-hook-widget add-zsh-hook
add-zle-hook-widget line-finish _transient_collapse
add-zsh-hook precmd _transient_restore

# Ctrl+C로 줄을 취소할 때도 줄인다 (TRAPINT는 tips.zsh에 있다)
zle -N _transient_collapse
typeset -ga _zle_abort_widgets
_zle_abort_widgets+=(_transient_collapse)
