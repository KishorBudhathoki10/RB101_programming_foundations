require 'pry'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
FIRST_PLAYER = 'player' # options: 'choose', 'player', 'computer'
WINNING_SCORE = 5

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  puts "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "          |     |"
  puts "       #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "          |     |"
  puts "     -----+-----+-----"
  puts "          |     |"
  puts "       #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "          |     |"
  puts "     -----+-----+-----"
  puts "          |     |"
  puts "       #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "          |     |"
  puts ""
  puts ''
end
# rubocop:enable Metrics/AbcSize

def quit_message
  puts "press (ctrl + z) to quit the game."
end

def joinor(arr, delimiter = ', ', word = 'or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def players_piece(brd)
  square = ''
  loop do
    prompt "Choose a position to place a piece: (#{joinor(empty_squares(brd))})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("Sorry, that's not a valid choice.")
  end
  square
end

def find_at_risk_square(line, brd, marker)
  if brd.values_at(*line).count(marker) == 2
    return brd.select { |k, v| line.include?(k) && v == ' ' }.keys.first
  end
  nil
end

def retrieve_at_risk_square(brd, marker)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, marker)
    break if square
  end
  square
end

def level_3_attack(brd)
  attack = [[3, 1], [3, 9], [1, 3], [1, 7]] +
           [[7, 1], [7, 9], [9, 3], [9, 7]].sample

  attack.each do |num|
    if brd[num] == INITIAL_MARKER
      return num
    end
  end
  false
end

def level_2_computer_play(brd)
  square = retrieve_at_risk_square(brd, PLAYER_MARKER)
  square = empty_squares(brd).sample if !square
  square = 5 if brd[5] == INITIAL_MARKER
  square
end

def level_3_computer_play(brd)
  square = retrieve_at_risk_square(brd, PLAYER_MARKER)
  return square = 5 if brd[5] == INITIAL_MARKER
  square = level_3_attack(brd) if !square
  square = empty_squares(brd).sample if !square
  square
end

def computers_piece(brd)
  # offense first
  square = retrieve_at_risk_square(brd, COMPUTER_MARKER)
  # defense
  if (LEVEL == '2') && !square
    return square = level_2_computer_play(brd)
  end

  if (LEVEL == '3') && !square
    return square = level_3_computer_play(brd)
  end

  square = empty_squares(brd).sample if !square
  square
end

def place_piece!(brd, current_player)
  if current_player == 'c'
    square = computers_piece(brd)
    brd[square] = COMPUTER_MARKER
  else
    square = players_piece(brd)
    brd[square] = PLAYER_MARKER
  end
end

def alternate_player(current_player)
  return 'p' if current_player == 'c'
  'c'
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd, player_name)
  !!detect_winner(brd, player_name)
end

def detect_winner(brd, player_name)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return player_name
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  false
end

def goes_first
  current_player = ''
  loop do
    current_player = gets.chomp
    break if current_player == 'c' || current_player == 'p'
    prompt("Please choose one. Type 'c' for computer or 'p' for player).")
  end
  current_player
end

def computer_won_match?(computers_score)
  computers_score == WINNING_SCORE
end

def clear_terminal
  system('clear') || system('cls')
end

def first_player_not_selected?
  FIRST_PLAYER == 'choose'
end

def display_result(player, computer, player_name)
  puts "  +------------------------------+"
  puts "  |        Current Scores        |"
  puts "  +------------------------------+"
  puts "     #{player_name}: #{player}  ||  Computer: #{computer}"
  puts "=========================================="
end

def retrieve_name
  name = ''
  loop do
    name = gets.chomp
    break if name.length <= 6 && name.length > 1 && name[0..1] != "  "
    prompt("Please enter minimum 2 and maximum 6 characters.")
  end
  name
end

def retrieve_game_mode
  mode = ''
  loop do
    mode = gets.chomp
    break if mode == '1' || mode == '2'
    prompt("Must choose: 1 or 2")
  end
  mode
end

def choose_level
  level = ''
  loop do
    level = gets.chomp
    break if ['1', '2', '3'].include?(level)
    prompt("Please select (1, 2, or 3).")
  end
  level
end

def five_matches_game_prompt
  puts ''
  puts "--- Any player who wins first five times is our Grand Winner. ---"
  puts ''
end

def instant_game_result(computers_score, player_score, player_name)
  if computers_score > player_score
    prompt("Computer won you.")
  elsif player_score > computers_score
    prompt("#{player_name} won this game.")
  else
    prompt("It is a tie.")
  end
end

def five_matches_game_result(computers_score, player_name)
  if computer_won_match?(computers_score)
    prompt("Computer is our Final Winner. Better luck next time.")
  else
    prompt("Congratulation #{player_name}! You are our Final Winner.")
  end
end

def game_mode_two_message(game_mode)
  five_matches_game_prompt if game_mode == '2'
end

def game_result(computers_score, player_score, player_name, game_mode)
  if game_mode == '2'
    five_matches_game_result(computers_score, player_name)
  else
    instant_game_result(computers_score, player_score, player_name)
  end
end

loop do
  system('clear')
  puts " ***Welcome to TIC-TAC-TOE game***"
  puts "==================================="

  prompt("Please enter your name. (Min character: 2 and Max characters: 6)")
  player_name = retrieve_name

  clear_terminal

  starter = FIRST_PLAYER

  if first_player_not_selected?
    prompt("Welcome! #{player_name}")
    prompt("Choose who starts. Enter 'c' for computer or 'p' for player")
    starter = goes_first
    clear_terminal
  end

  puts"              Select Mode:"
  puts '--------------------------------------------'
  puts "1) Instant game   ||  2) Five matches to win"
  puts''
  prompt("Choose 1 or 2")
  game_mode = retrieve_game_mode

  clear_terminal

  different_levels = <<-MSG
  Welcome #{player_name}
  Please select the game level:
  1. Easy
  2. Medium
  3. Hard
  MSG

  prompt(different_levels)
  puts '-------------------------------'
  prompt("Type (1, 2 or 3)")
  level = choose_level

  LEVEL = level

  player_score = 0
  computers_score = 0
  round = 1

  loop do
    board = initialize_board
    current_player = starter

    loop do
      clear_terminal
      prompt("Round: #{round}")

      display_result(player_score, computers_score, player_name)
      game_mode_two_message(game_mode)
      display_board(board)
      quit_message
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board, player_name) || board_full?(board)
    end

    clear_terminal

    if detect_winner(board, player_name) == player_name
      player_score += 1
    elsif detect_winner(board, player_name) == 'Computer'
      computers_score += 1
    end

    prompt("Round: #{round}")
    display_result(player_score, computers_score, player_name)
    game_mode_two_message(game_mode)
    display_board(board)
    quit_message

    if someone_won?(board, player_name)
      prompt("#{detect_winner(board, player_name)} won!")
    else
      prompt("It's a tie!")
    end

    break if game_mode == '1'
    break if player_score == WINNING_SCORE || computers_score == WINNING_SCORE

    round += 1

    if first_player_not_selected?
      prompt("Choose who starts in Round #{round}: 'p' player or 'c' computer)")
      starter = goes_first
    else
      prompt("Press enter to start Round #{round}.")
      gets.chomp
      starter = alternate_player(starter)
    end
  end

  sleep(4)
  clear_terminal

  game_result(computers_score, player_score, player_name, game_mode)

  puts "------------------------------------------------"
  prompt("Do you want to play again? Type 'y' and hit enter to repeat.")
  prompt "If you type other letters the game will exit."
  repeat = gets.chomp
  break if repeat.downcase != 'y'
end

prompt("Thanks for playing Tic Tac Toe.")

sleep(6)
clear_terminal
