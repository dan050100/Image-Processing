function values = normalize_vector(v)
values = v/norm(v)
end

function n = norm(v)
n = sqrt(sum(v.^2))
end

