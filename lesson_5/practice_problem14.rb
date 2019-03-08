arr = [{a: [1, 2, 3]}, {b: [2, 4, 6], c: [3, 6], d: [4]}, {e: [8], f: [6, 10]}]

b = []

arr.select do |hsh|
  new_hsh = {}
  hsh.select do |k, v|
    new_hsh[k] = v if v.all? { |num| num.even? }
    b = [new_hsh]
  end
end

p b

=begin

According to book:

arr.select do |hsh|
  hsh.all? do |_, value|
    value.all? do |num|
      num.even?
    end
  end
end
# => [{:e=>[8], :f=>[6, 10]}]

=end