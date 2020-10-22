function pic = slice(img, vec, newval)

pic = imread(img);
pic(pic > vec(1) & pic < vec(end)) = newval;

end

