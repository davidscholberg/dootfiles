# set bash-like tab completion
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# ctrl-d noises
Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit

# custom prompt
function prompt {
    return ((&"prompterino.exe") -join "`n")
}

# visual studio shit
function Vsify-Pwsh {
    Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell f3a6440e -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"
}
