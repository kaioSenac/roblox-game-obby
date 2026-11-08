return function(t, first, last)
    local result = {}
    for i = first, last do
        local v = t[i]
        if type(v) == "table" then
            local new = {}
            for k, val in pairs(v) do
                new[k] = val
            end
            result[#result + 1] = new
        else
            result[#result + 1] = v
        end
    end
    return result
end