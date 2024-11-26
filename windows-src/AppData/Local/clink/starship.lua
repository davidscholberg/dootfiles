-- Manage SHLVL manually
clink.oninject(function ()
    shlvl = os.getenv("SHLVL")
    if (not shlvl) then
        -- This should be set to 1, but there's a bug with the shlvl handling in bash, so we compensate for it here.
        os.setenv("SHLVL", "0")
        return
    end

    shlvl_num = tonumber(shlvl)
    if (not shlvl_num) then
        return
    end

    os.setenv("SHLVL", tostring(shlvl_num + 1))
end)

-- Load starship config
load(io.popen('starship init cmd'):read("*a"))()
