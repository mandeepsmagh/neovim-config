return function(fn)
    local done = false
    return function(...)
        if done then return end
        done = true
        return fn(...)
    end
end
