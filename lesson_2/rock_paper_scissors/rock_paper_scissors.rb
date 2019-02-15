VALID_CHOICES = { '1' => 'rock',
                  '2' => 'paper',
                  '3' => 'scissors',
                  '4' => 'lizard',
                  '5' => 'spock' }

WINNING_PIECES = { 'rock' => %w(scissors lizard),
                   'paper' => %w(rock spock),
                   'scissors' => %w(paper lizard),
                   'lizard' => %w(paper spock),
                   'spock' => %w(rock scissors) }

def test_method
  prompt('test message')
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def result(player, computer)
  if WINNING_PIECES[player].include?(computer)
    "You won!"
  elsif WINNING_PIECES[computer].include?(player)
    "Computer won!"
  else
    "It's a tie!"
  end
end

def current_score(player, computer)
  puts "+---------------------+"
  puts "|   Current Score:    |"
  puts "|   You: #{player}            |"
  puts "|   Computer: #{computer}       |"
  puts "+---------------------+"
end

system('clear') || system('cls')

prompt("Welcome to the Rock Paper Scissors Lizard and Spock game.")
prompt("Any player who wins first 5 times will be our Grand Winner.")

your_score = 0
computer_score = 0

loop do
  choice = ''
  loop do
    choosing_option = <<-MSG
    Choose one(number) from the following option:
    1) rock
    2) paper
    3) scissors
    4) lizard
    5) spock
    MSG

    prompt(choosing_option)
    choice = Kernel.gets().chomp()

    break if %w(1 2 3 4 5).include?(choice)
    prompt("That's not a valid choice.")
  end

  computer_choice = VALID_CHOICES.values.sample

  choice = VALID_CHOICES[choice]

  system('clear') || system('cls')

  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

  display_result = result(choice, computer_choice)

  prompt(display_result)

  if display_result == 'You won!'
    your_score += 1
  elsif display_result == 'Computer won!'
    computer_score += 1
  end

  current_score(your_score, computer_score)

  if your_score == 5
    prompt("Congratulations! You are the Grand Winner.")
    break
  elsif computer_score == 5
    prompt("Tough luck! Computer is the Grand Winner.")
    break
  end
end

prompt("Thank you for playing. Good bye!")
