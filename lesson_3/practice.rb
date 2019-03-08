OPTIONS = "Please select one of the options: r = Rock"\
          ", p = Paper, s = Scissors, l = Lizard, c = Spock"
VALID_CHOICES = %w(r p s l c)
SCORE_NEEDED_TO_WIN_GAME = 5

def prompt(message)
  Kernel.puts("=> #{message}")
end

def get_choice()
  prompt("Do you want to play again?(Y/N)")
  answer = Kernel.gets().chomp()
end

def win?(first, second)
  choices_results = {
    "r" => ["s", "l"],
    "p" => ["r", "c"],
    "s" => ["p", "l"],
    "l" => ["c", "p"],
    "c" => ["r", "s"]
  }

  choices_results.values_at(first).flatten.include?(second)
end

def display_result(player, computer)
  if win?(player, computer)
    prompt("You won!")
  elsif win?(computer, player)
    prompt("Computer Wins!")
  else
    prompt("It's a tie!")
  end
end

choice = ''
user_score = 0
computer_score = 0

loop do # main loop
  loop do # loop to get/validate choice from user
    prompt("Choose one: #{OPTIONS}")
    choice = Kernel.gets().chomp()
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice")
    end
  end
  computer_choice = VALID_CHOICES.sample
  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")
  
  if win?(choice, computer_choice)
    user_score += 1
  elsif win?(computer_choice, choice)
    computer_score += 1
  end

  display_result(choice, computer_choice)

  prompt("Your score: #{user_score},"\
    " Computer score: #{computer_score}")

  if user_score >= SCORE_NEEDED_TO_WIN_GAME
    prompt("You are the Grand Champion!!")
    break unless get_choice.downcase().start_with?('y')
    system 'cls'
    user_score = 0
    computer_score = 0
  elsif computer_score >= SCORE_NEEDED_TO_WIN_GAME
    prompt("The computer is champ, you lose")
    break unless get_choice.downcase().start_with?('y')
    system 'cls'
    user_score = 0
    computer_score = 0
  end
end
prompt("Thanks for playing!!")