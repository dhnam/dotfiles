-- navi: Ctrl+G로 명령어 모음(~/.config/navi/cheats)을 검색해서 입력 칸에 넣는다 (PowerShell 프로필과 같은 동작).
-- 입력 중인 글자가 있으면 검색어로 쓴다.

os.setenv("NAVI_PATH", os.getenv("USERPROFILE") .. "\\.config\\navi\\cheats")

function navi_widget(rl_buffer)
    local line = rl_buffer:getbuffer()
    local command = "navi --print"
    if line ~= "" then
        command = command .. ' --query "' .. line:gsub('"', "") .. '"'
    end
    local f = io.popen(command)
    if not f then
        rl_buffer:ding()
        return
    end
    local out = f:read("*a"):gsub("[\r\n]+$", "")
    f:close()
    if out ~= "" then
        rl_buffer:beginundogroup()
        rl_buffer:remove(1, rl_buffer:getlength() + 1)
        rl_buffer:insert(out)
        rl_buffer:endundogroup()
    end
    rl_buffer:refreshline()
end

rl.describemacro([["luafunc:navi_widget"]], "navi 명령어 모음 검색")
rl.setbinding([["\C-g"]], [["luafunc:navi_widget"]])
