# set bash-like tab completion
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# custom prompt
function prompt {
    return ((&"prompterino.exe") -join "`n")
}
