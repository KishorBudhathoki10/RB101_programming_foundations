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
  prompt("Any player who wins first 5 times is our final Winner.")
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
end
# rubocop:enable Metrics/AbcSize

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

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    return board.select { |k, v| line.include?(k) && v == ' ' }.keys.first
  end
  nil
end

def find_square(brd, marker)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, marker)
    break if square
  end
  square
end

def level_3_attack(brd)
  [3, 1, 7, 9].each do |num|
    if brd[num] == INITIAL_MARKER
      return num
    end
  end
end

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
# rubocop:disable Metrics/AbcSize
def computers_piece(brd)
  # offense first
  square = find_square(brd, COMPUTER_MARKER)
  # defense
  if (LEVEL == '3' || LEVEL == '2') && !square
    square = find_square(brd, PLAYER_MARKER)
  end

  if !square
    square = empty_squares(brd).sample
    if LEVEL == '3'
      return square = 5 if brd[5] == INITIAL_MARKER
      square = level_3_attack(brd)
    elsif LEVEL == '2'
      square = 5 if brd[5] == INITIAL_MARKER
    end
  end
  square
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
# rubocop:enable Metrics/AbcSize

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

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
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

def display_result(player, computer)
  puts "     +-------------------+"
  puts "     |   Current Scores  |"
  puts "     |-------------------|"
  puts "     |   Your: #{player}       |"
  puts "     |   Computer: #{computer}     |"
  puts "     +-------------------+"
  puts "====================================="
end

system('clear')
prompt("Welcome to TIC-TAC-TOE game.")
starter = FIRST_PLAYER

if FIRST_PLAYER == 'choose'
  prompt("Choose who starts. Enter 'c' for computer or 'p' for player")
  starter = goes_first
end
choose_level = <<-MSG
Please select one game level:
1. Easy
2. Medium
3. Hard
Type (1, 2 or 3)
MSG

prompt(choose_level)
level = ''
loop do
  level = gets.chomp
  break if ['1', '2', '3'].include?(level)
  prompt("Please select (1, 2, or 3).")
end

LEVEL = level

player_score = 0
computers_score = 0
round = 1

loop do
  board = initialize_board
  current_player = starter

  loop do
    system('clear')
    prompt("Round: #{round}")

    display_result(player_score, computers_score)
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  system('clear')

  if detect_winner(board) == 'Player'
    player_score += 1
  elsif detect_winner(board) == 'Computer'
    computers_score += 1
  end

  prompt("Round: #{round}")
  display_result(player_score, computers_score)
  display_board(board)

  if someone_won?(board)
    prompt("#{detect_winner(board)} won!")
  else
    prompt("It's a tie!")
  end

  break if player_score == WINNING_SCORE || computers_score == WINNING_SCORE

  round += 1

  if FIRST_PLAYER == 'choose'
    prompt("Choose who starts in Round #{round}: 'p' player or 'c' computer) ")
    starter = goes_first
  else
    prompt("Press enter to start Round #{round}.")
    gets.chomp
    starter = alternate_player(starter)
  end
end

sleep(4)
system('clear')

if computers_score == WINNING_SCORE
  prompt("Computer is our Final Winner. Better luck next time.")
else
  prompt("Congratulation! You are our Final Winner.")
end

prompt("Thanks for playing Tic Tac Toe.")

sleep(6)
system('clear')
