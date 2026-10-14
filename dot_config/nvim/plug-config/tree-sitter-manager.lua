-- Windows의 tree-sitter CLI는 기본으로 MSVC(cl.exe)를 찾는다. Visual Studio 없이 gcc(WinLibs)만
-- 설치해 쓰므로, nvim 안에서만 CC를 gcc로 지정해 파서 빌드가 되게 한다.
if vim.fn.has("win32") == 1 and vim.env.CC == nil and vim.fn.executable("gcc") == 1 then
	vim.env.CC = "gcc"
end

require("tree-sitter-manager").setup({})
