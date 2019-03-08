def multiply(arr_of_nums, multiplier)
  multiplied_arr = []
  counter = 0

  loop do
    multiplied_arr << (arr_of_nums[counter] * multiplier)
    counter += 1

    break if counter == arr_of_nums.size
  end 

  multiplied_arr
end

my_numbers = [1, 4, 3, 7, 2, 6]
p multiply(my_numbers, 3)
p my_numbers
