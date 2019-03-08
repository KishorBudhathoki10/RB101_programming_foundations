statement = 'The Flintstones Rock'
statement = statement.split(//)
count_letters = {}

statement.each do |l|
  if count_letters.key?(l)
    count_letters[l] += 1
  elsif l == ' '
    l
  else
    count_letters[l] = 1
  end
end

p count_letters
