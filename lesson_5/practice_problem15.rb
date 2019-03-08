=begin

I did it this way

def generate_UUID
  hexadecimal_chars = %w(a b c d e f 1 2 3 4 5 6 7 8 9)
  uuid_string = ''
  32.times do
    uuid_string << hexadecimal_chars.sample
    uuid_string << '-' if uuid_string.size == 8 || uuid_string.size == 13 || uuid_string.size == 18 || uuid_string.size == 23
  end
  uuid_string
end

puts generate_UUID

=end

def generate_UUID
  characters = []
  (0..9).each { |digit| characters << digit.to_s }
  ('a'..'f').each { |digit| characters << digit }

  uuid = ''
  sections = [8, 4, 4, 4, 12]
  sections.each_with_index do |section, index|
    section.times { uuid += characters.sample }
    uuid += '-' if uuid.size < 24
  end

  uuid
end

puts generate_UUID
