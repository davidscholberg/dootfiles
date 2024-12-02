local M = {}

-- Splits string by the given separator.
function M.split(str, sep)
    if str:len() == 0 then
        return {}
    end

    local arr = {}

    local next_start = 1
    while true do
        local i = str:find(sep, next_start)

        if i == nil then
            arr[#arr + 1] = str:sub(next_start, str:len())
            break
        end

        arr[#arr + 1] = str:sub(next_start, i - 1)
        next_start = i + sep:len()

        if next_start > str:len() then
            arr[#arr + 1] = ""
            break
        end
    end

    return arr
end

return M
