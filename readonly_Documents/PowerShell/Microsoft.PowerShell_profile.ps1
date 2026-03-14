
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
Invoke-Expression (&starship init powershell)
#f45873b3-b655-43a6-b217-97c00aa0db58

# mise 활성화
mise activate pwsh | Out-String | Invoke-Expression

# Alias 설정
function eza-tree-wrapper { eza --tree --icons $args }
Set-Alias ls eza
Set-Alias tree eza-tree-wrapper
Set-Alias find fd
Set-Alias grep rg
Set-Alias vi nvim
Set-Alias vim nvim

# FZF 설정 (파워셸용 fzf 모듈을 따로 설치해야 더 원활합니다)
$env:FZF_DEFAULT_OPTS="--preview-window=right:60% --preview 'if (Test-Path -PathType Container {}) { eza --tree --level=2 --color=always {} } else { bat --style=numbers --color=always --line-range :500 {} }'"

# zoxide 및 starship 초기화
starship init powershell | Out-String | Invoke-Expression
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
