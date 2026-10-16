-- 바로 전 프롬프트와 같은 디렉터리면 지난 프롬프트를 `❯` 한 줄로 줄인다 (zsh, PowerShell과 같은 규칙).
-- starship init cmd는 이 함수가 먼저 정의되어 있으면 transient 프롬프트로 쓴다.
function starship_transient_prompt_func(prompt) -- luacheck: no unused args
    return "\x1b[1;38;5;76m❯\x1b[0m "
end

load(io.popen('starship init cmd'):read('*a'))()

clink.onbeginedit(function()
    if settings.get("prompt.transient") ~= "same_dir" then
        settings.set("prompt.transient", "same_dir")
    end
end)
