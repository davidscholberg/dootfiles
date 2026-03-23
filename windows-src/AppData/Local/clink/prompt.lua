local custom_prompt = clink.promptfilter(0)

function custom_prompt:filter()
    return io.popen('prompterino.exe'):read("*a")
end
