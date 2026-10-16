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

# Transient prompt. 명령을 입력한 프롬프트가 바로 전 프롬프트와 같은 디렉터리면 `❯` 한 줄로 줄이고,
# 디렉터리가 바뀐 뒤 첫 프롬프트는 전체를 화면 기록에 남긴다 (zsh의 transient-prompt.zsh,
# clink의 prompt.transient = same_dir과 같은 규칙). Ctrl+C로 취소한 줄도 같다.
# starship의 Enable-TransientPrompt는 항상 줄이므로 쓰지 않고, 줄일 때만 starship 모듈의
# TransientPrompt 플래그를 켜고 다시 그린다. 줄이지 않을 때는 다시 그리지 않으니 화면의 전체
# 프롬프트는 starship이 원래 인자(직전 명령 상태, 실행 시간 등)로 그린 그대로 남는다.
if (Get-Command Enable-TransientPrompt -ErrorAction Ignore) {
    # starship init의 New-Module은 가져오기(import)가 안 되어 Get-Module로는 찾을 수 없다
    $global:__transient = @{ Module = (Get-Command Enable-TransientPrompt).Module; PrevPwd = $null }
    function global:Invoke-Starship-TransientFunction { "$([char]27)[1;38;5;76m❯$([char]27)[0m " }
    function global:__transient_collapse {
        $t = $global:__transient
        if ($null -ne $t.PrevPwd -and $PWD.Path -eq $t.PrevPwd) {
            & $t.Module { $script:TransientPrompt = $true }
            [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
        }
        $t.PrevPwd = $PWD.Path
    }
    Set-PSReadLineKeyHandler -Key Enter -BriefDescription 'AcceptLine (transient prompt)' -ScriptBlock {
        $errors = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$null, [ref]$errors, [ref]$null)
        # 괄호가 안 닫히는 등 입력이 이어지는 중이면 아직 줄이 끝난 게 아니다
        if (-not ($errors | Where-Object IncompleteInput)) { __transient_collapse }
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
    Set-PSReadLineKeyHandler -Chord Ctrl+c -BriefDescription 'CopyOrCancelLine (transient prompt)' -ScriptBlock {
        $start = $length = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$start, [ref]$length)
        if ($length -le 0) { __transient_collapse }  # 선택 영역이 있으면 복사만 한다
        [Microsoft.PowerShell.PSConsoleReadLine]::CopyOrCancelLine()
    }
}

# navi: Ctrl+G로 명령어 모음(~/.config/navi/cheats)을 검색해서 입력 칸에 넣는다.
# 입력 중인 글자가 있으면 검색어로 쓴다. `navi widget power-shell`은 위젯이 아니라 모듈을 복사하고
# $PROFILE에 줄을 덧붙이는 설치 스크립트라서 쓰지 않고 직접 만든다.
if (& $__has navi) {
    $env:NAVI_PATH = "$HOME\.config\navi\cheats"
    # keys.cheat의 `: 키` 줄을 실행해도 괜찮도록 sh의 `:`처럼 아무것도 하지 않는 명령
    function global:: { }
    Set-PSReadLineKeyHandler -Chord Ctrl+g -BriefDescription 'navi 명령어 모음 검색' -ScriptBlock {
        $line = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
        $naviArgs = @('--print')
        if ($line) { $naviArgs += '--query', $line }
        $out = (navi @naviArgs | Out-String).Trim()
        if ($out) { [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, $out) }
    }
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
