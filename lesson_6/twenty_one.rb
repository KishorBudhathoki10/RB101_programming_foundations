HAND_LIMIT = 21
COMPUTER_LIMIT = 17
SUITS = ['Heart', 'Diamond', 'Spades', 'Clubs']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
WINNING_SCORE = 5

def prompt(msg)
  puts "=> #{msg}"
end

def clear_terminal
  system('clear') || system('cls')
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def calculate_total(cards)
  values = cards.map { |card| card[1] }
  total = 0

  values.each do |card|
    total += if ['J', 'Q', 'K'].include?(card)
               10
             elsif card == 'A'
               11
             else
               card.to_i
             end
  end

  values.select { |card| card == 'A' }.count.times do
    total -= 10 if total > HAND_LIMIT
  end

  total
end

def game_welcome_msg
  puts "       *** Welcome to Twenty-One game. ***"
  puts "==================================================="
  puts ''
end

def ask_and_retrieve_name
  prompt("Please enter your name. (Min character: 2 and Max character: 6)")
  name = ''
  loop do
    name = gets.chomp
    break if name.length <= 6 && name.length > 1 && name[0..1] != "  "
    prompt("Please enter minimum 2 and maximum 6 characters.")
  end
  name
end

def show_player_cards(player_cards, player_name)
  puts ""
  prompt("#{player_name} you have following cards:")
  player_cards.each_with_index do |card, idx|
    idx += 1
    print "#{idx}) #{card[1]} of #{card[0]}     "
  end
  puts ''
  puts ''
end

def show_computer_cards(computer_cards)
  prompt("Computer has following cards:")
  computer_cards.each_with_index do |card, idx|
    idx += 1
    print "#{idx}) #{card[1]} of #{card[0]}     "
  end
  puts ''
  puts ''
end

def show_one_card_of_computer(computer_cards)
  prompt "Computer's one card is:"
  puts "1) #{computer_cards[0][1]} of #{computer_cards[0][0]}"
  puts ''
  puts ''
end

def player_hit_or_stay(player_name, player_cards, deck, players_total)
  loop do
    prompt("#{player_name} your want to hit or stay?")
    prompt "Type 'h' for hit or 's' for stay. Press (ctrl+z) to quit."
    answer = hit_or_stay(player_cards, deck, players_total)
    players_total = calculate_total(player_cards)
    break if answer == 's' || busted?(players_total)
  end
end

def hit_or_stay(player_cards, deck, players_total)
  answer = ''
  loop do
    answer = gets.chomp
    if answer == 'h'
      player_cards << deck.pop
      prompt "Your new card is #{player_cards[-1][1]} of #{player_cards[-1][0]}"
      prompt "Your total is: #{calculate_total(player_cards)}"
      puts ""
      break
    end
    break if answer == 's' || busted?(players_total)

    prompt("Invalid input. You must type 'h'  or 's'.")
  end
  answer
end

def busted?(cards)
  cards > HAND_LIMIT
end

def computer_hit_or_stay(computer_cards, deck, computers_total)
  loop do
    break if computers_total >= COMPUTER_LIMIT || busted?(computers_total)
    computer_cards << deck.pop
    computers_total = calculate_total(computer_cards)
  end
end

def computer_won?(computers_total, players_total)
  computers_total > players_total
end

def player_won?(players_total, computers_total)
  players_total > computers_total
end

def declare_winner(players_total, computers_total, player_name)
  if computer_won?(computers_total, players_total)
    prompt "Computer won you."
  elsif player_won?(players_total, computers_total)
    prompt "Congratulation #{player_name}! You won this game."
  else
    prompt "It's a tie."
  end
  puts ''
end

def play_again?
  prompt("Play again? (Type 'y' and press enter to repeat)")
  prompt "If you type other letters the game will exit."
  repeat = gets.chomp
  repeat.downcase == 'y'
end

def stop_unless_hit_enter
  prompt("Type any key and hit enter to continue.")
  gets.chomp
end

def show_total(computers_total, players_total, player_name)
  puts ''
  puts "           ***Total***"
  puts "---------------------------------"
  puts "Computer: #{computers_total}    ||" \
       "    #{player_name}: #{players_total}"
  puts ""
end

def computer_busted_msg(player_name, computers_total)
  prompt "Computer is busted! #{player_name} you won this game."
  prompt "Computer's total is: #{computers_total}."
  puts ''
  stop_unless_hit_enter
  clear_terminal
end

def player_busted_msg(player_name, players_total)
  prompt "#{player_name} you are busted! Computer won this game."
  prompt "Your total is: #{players_total}."
  puts ''
  stop_unless_hit_enter
  clear_terminal
end

def game_mode_msg
  puts"              Select Mode:"
  puts '--------------------------------------------'
  puts "1) Instant game   ||  2) Five matches to win"
  puts''
  prompt("Choose 1 or 2")
end

def retrieve_game_mode
  mode = ''
  loop do
    mode = gets.chomp
    break if ['1', '2'].include?(mode)
    prompt("Sorry, must choose 1 or 2.")
  end
  mode
end

def mode_starting_msg(game_mode)
  if game_mode == '1'
    prompt "Starting Instant game mode....."
  else
    prompt "Initializing Five matches to win mode....."
  end
end

def someone_won?(player_score, computer_score)
  player_score == WINNING_SCORE || computer_score == WINNING_SCORE
end

def five_matches_game_prompt
  puts ''
  puts "--- Any player who wins first five times is our Grand Winner. ---"
end

def show_round(round)
  puts "Round: #{round}"
end

def show_current_scores(player_name, player_score, computer_score)
  puts "        --Current Score--"
  puts "Computer: #{computer_score}     ||     #{player_name}: #{player_score}"
end

def game_mode_two?(game_mode)
  game_mode == '2'
end

loop do
  clear_terminal

  game_welcome_msg
  player_name = ask_and_retrieve_name.capitalize

  clear_terminal

  game_mode_msg
  game_mode = retrieve_game_mode

  clear_terminal

  prompt("Welcome #{player_name}!")
  mode_starting_msg(game_mode)
  sleep(2)

  clear_terminal

  player_score = 0
  computer_score = 0
  round = 0

  loop do
    prompt "Dealing cards to player and computer......."
    sleep(2)

    clear_terminal

    loop do
      deck = initialize_deck
      player_cards = []
      computer_cards = []
      round += 1

      2.times do
        player_cards << deck.pop
        computer_cards << deck.pop
      end

      players_total = calculate_total(player_cards)
      computers_total = calculate_total(computer_cards)

      show_round(round)
      show_current_scores(player_name, player_score, computer_score)

      five_matches_game_prompt if game_mode_two?(game_mode)
      show_player_cards(player_cards, player_name)

      puts '---------------------------------------'
      puts ''
      show_one_card_of_computer(computer_cards)

      player_hit_or_stay(player_name, player_cards, deck, players_total)
      players_total = calculate_total(player_cards)

      clear_terminal

      if busted?(players_total)
        show_player_cards(player_cards, player_name)
        player_busted_msg(player_name, players_total)
        computer_score += 1
        break
      end

      prompt("Computer is making his move......")
      sleep(3)

      clear_terminal

      computer_hit_or_stay(computer_cards, deck, computers_total)

      computers_total = calculate_total(computer_cards)

      show_round(round)
      show_current_scores(player_name, player_score, computer_score)

      show_player_cards(player_cards, player_name)

      show_computer_cards(computer_cards)

      if busted?(computers_total)
        computer_busted_msg(player_name, computers_total)
        player_score += 1
        break
      end

      show_total(computers_total, players_total, player_name)

      computer_score += 1 if computers_total > players_total
      player_score += 1 if computers_total < players_total

      declare_winner(players_total, computers_total, player_name)

      stop_unless_hit_enter

      clear_terminal
      break
    end

    break if game_mode == '1'

    if someone_won?(player_score, computer_score)
      if computer_won?(computer_score, player_score)
        prompt "Computer is our grand winner. He beat you five times."
      else
        prompt "Comgratulations #{player_name}! You are our Grand Master."
      end
      puts ''
      break
    end
  end

  break unless play_again?
end

prompt "Thank you for playing Twenty-One. See you soon."
sleep(3)
clear_terminal
