hsh = {
  'grape' => {type: 'fruit', colors: ['red', 'green'], size: 'small'},
  'carrot' => {type: 'vegetable', colors: ['orange'], size: 'medium'},
  'apple' => {type: 'fruit', colors: ['red', 'green'], size: 'medium'},
  'apricot' => {type: 'fruit', colors: ['orange'], size: 'medium'},
  'marrow' => {type: 'vegetable', colors: ['green'], size: 'large'},
}

arr = []

hsh.values.each do |sub_hsh|
  if sub_hsh[:type] == 'fruit'
    sub_hsh[:colors].each do |color|
      color.capitalize!
    end
    arr << sub_hsh[:colors]
  else
    arr << sub_hsh[:size].upcase
  end
end

p arr
