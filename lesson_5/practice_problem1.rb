arr = ['10', '11', '9', '7', '8']

descending_sort = arr.sort do |n, o|
  o.to_i <=> n.to_i
end

p descending_sort
