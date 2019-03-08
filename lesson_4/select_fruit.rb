def select_fruit(items)
  products = items.keys
  fruits = {}
  counter = 0

  loop do
    if items[products[counter]] == 'Fruit'
      fruits[products[counter]] = 'Fruit'
    end
    counter += 1
    break if counter == products.size
  end

  fruits
end

produce = {
  'apple' => 'Fruit',
  'carrot' => 'Vegetable',
  'pear' => 'Fruit',
  'broccoli' => 'Vegetable'
}

p select_fruit(produce)
