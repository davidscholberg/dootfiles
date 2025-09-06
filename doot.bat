robocopy /e windows-src\ %userprofile%

:: install/clean nvim plugins
nvim --headless -u NONE -c "luafile %LOCALAPPDATA%\nvim\lua\include\paq_spec.lua" -c PaqClean -c PaqInstall -c qa
