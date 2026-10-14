# 공용 PowerShell 프로필 (chezmoi 관리).
# $PROFILE 본체는 PowerToys(CommandNotFound), coreutils 등이 자동으로 블록을 써넣는 파일이라
# chezmoi로 관리하지 않고, 거기서 이 파일을 불러오기만 한다. (run_after_pwsh-profile 참고)
# 아직 도구가 깔리지 않은 PC에서도 오류 없이 열리도록 전부 존재 여부를 확인하고 실행한다.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$__has = { param($name) [bool](Get-Command $name -ErrorAction Ignore) }

# mise 활성화 (아래 도구들이 mise로 설치되므로 가장 먼저)
if (& $__has mise) {
    mise activate pwsh | Out-String | Invoke-Expression
}

# FZF 설정
if (& $__has fzf) {
    $env:FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    $env:FZF_DEFAULT_OPTS = "--preview-window=right:60% --preview 'dir /a:d {} >nul 2>&1 && eza --tree --level=2 --color=always {} || bat --style=numbers --color=always --line-range :500 {}'"
    if (& $__has Invoke-FzfTabCompletion) {
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    }
}

# starship 및 zoxide 초기화
if (& $__has starship) {
    starship init powershell | Out-String | Invoke-Expression
}
if (& $__has zoxide) {
    Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
}

# 명령 대체. ls/find/grep은 coreutils 통합에서 꺼 두었기 때문에(부트스트랩의 DisabledUtilities)
# 여기 함수가 그대로 쓰인다.
if (& $__has eza) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue
    function global:ls { eza --icons @args }
    function global:la { eza --icons -la @args }
    function global:tree { eza --tree --icons @args }
}
if (& $__has fd) {
    function global:find { fd @args }
}
if (& $__has rg) {
    function global:grep { rg @args }
}
if (& $__has nvim) {
    function global:vi { nvim @args }
    function global:vim { nvim @args }
}

Remove-Variable __has
