# 입력 칸이 비어 있을 때 옅은 글씨로 도구 팁 하나를 보여 준다.
# 팁은 navi 명령어 모음($NAVI_PATH/*.cheat)의 "# 설명" + 명령 쌍과 아래 단축키 목록에서 고른다.
# 화면에만 그리는 글자(POSTDISPLAY)라서 실행되지 않고, 오른쪽 화살표를 누르면 입력 칸으로 가져온다.

typeset -ga _tip_list=(
  'Ctrl+T  # fzf: 파일을 골라 경로를 입력 칸에 넣기'
  'Ctrl+R  # fzf: 명령 기록 검색'
  'Alt+C  # fzf: 하위 폴더를 골라 이동'
  'Ctrl+G  # navi: 명령어 모음 검색해서 입력 칸에 넣기'
  'Win+V  # 클립보드 기록'
)

() {
  local file line desc
  for file in ${(s.:.)NAVI_PATH}/*.cheat(N); do
    desc=
    while IFS= read -r line; do
      case $line in
        ('# '*) desc=${line#\# } ;;
        ('') ;;
        ('%'*|'$'*|';'*) desc= ;;
        (*) [[ -n $desc ]] && _tip_list+=("$line  # $desc"); desc= ;;
      esac
    done < $file
  done
}

typeset -g _tip_current _tip_style='fg=8'

# 지금 보여 줄 팁을 POSTDISPLAY에 넣거나 걷어 낸다
_tip_apply() {
  region_highlight=("${(@)region_highlight:#* memo=tip}")
  if [[ -z $BUFFER && -n $_tip_current && ( -z $POSTDISPLAY || $POSTDISPLAY == $_tip_current ) ]]; then
    POSTDISPLAY=$_tip_current
    region_highlight+=("0 $#POSTDISPLAY $_tip_style memo=tip")
  elif [[ -n $BUFFER && $POSTDISPLAY == $_tip_current ]]; then
    POSTDISPLAY=
  fi
}

_tip_line_init() {
  (( $#_tip_list )) && _tip_current=${_tip_list[RANDOM % $#_tip_list + 1]}
  _tip_apply
}

# 줄을 끝낼 때 팁이 화면 기록에 남지 않게 지운다
_tip_clear() {
  if [[ $POSTDISPLAY == $_tip_current ]]; then
    POSTDISPLAY=
    region_highlight=("${(@)region_highlight:#* memo=tip}")
    zle -R
  fi
  # 이 뒤에 다시 그려질 때(transient prompt 등) 팁을 또 넣지 않게 한다
  _tip_current=
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init _tip_line_init
add-zle-hook-widget line-pre-redraw _tip_apply
add-zle-hook-widget line-finish _tip_clear

# Ctrl+C로 줄을 취소하면 line-finish가 불리지 않으므로 여기서도 지운다.
# Ctrl+C 때 부를 위젯은 _zle_abort_widgets에 모은다 (transient-prompt.zsh도 같이 쓴다)
zle -N _tip_clear
typeset -ga _zle_abort_widgets
_zle_abort_widgets+=(_tip_clear)
(( $+functions[TRAPINT] )) || TRAPINT() {
  local widget
  if zle; then
    for widget in $_zle_abort_widgets; do zle $widget; done
  fi
  return $(( 128 + $1 ))
}
