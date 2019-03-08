=begin

input: string
output: specified letters

rules:
  - create a variable named result and assign it a empty string
  - create a counter variable and give value 0.
  - start a loop and break when counter is equal to string's length.
    - select each letter infividually using String and counter
    - compare it with the spicified character
    - add the character to the result variable we created if matches character matches
    - add 1 to counter variable.
  - return result variable

=end

def select_letter(sentence, character)
  selected_chars = ''
  counter = 0

  loop do
    current_chars = sentence[counter]
    selected_chars << current_chars if current_chars == character
    counter += 1
    break if counter == sentence.size
  end

  selected_chars
end

question = 'How many times does a particular character appear in this sentence?'
p select_letter(question, 'a')
p select_letter(question, 't')
puts select_letter(question, 'z')
