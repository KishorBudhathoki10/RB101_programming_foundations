require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def messages(message, lang)
  if lang != 'es'
    lang = 'en'
  end
  prompt(MESSAGES[lang][message])
end

def valid_number?(num)
  integer?(num) || float?(num)
end

def integer?(num)
  num.to_i == (Integer(num) rescue nil)
end

def float?(num)
  num.to_f == (Float(num) rescue nil)
end

def operation_to_message(op)
  case op
  when '1'
    "Adding the two numbers...."
  when '2'
    "Subtracting the two numbers...."
  when '3'
    "Multiplying the two numbers...."
  when '4'
    "Dividing the two numbers...."
  end
end

def operacion_a_mensaje(op)
  case op
  when '1'
    "Añadiendo los dos numeros...."
  when '2'
    "Sustraiendo los dos numeros...."
  when '3'
    "Multiplicando los dos numeros...."
  when '4'
    "Dividiendo los dos numeros...."
  end
end

language = <<-MSG
Choose your language:
1) Type 'es' for spanish
2) Type 'en' for english

note: If nothing is typed we will use english as our default language.
MSG

prompt(language)

lang = Kernel.gets().chomp()

messages('welcome', lang)

name = ''

loop do
  name = Kernel.gets().chomp()

  if name.empty?()
    messages('valid_name', lang)
  else
    break
  end
end

messages('greeting', lang)
prompt("#{name}. :-)")

loop do
  number1 = ''

  loop do
    messages('first_num', lang)
    number1 = Kernel.gets().chomp()

    if valid_number?(number1)
      break
    else
      messages('valid_number', lang)
    end
  end

  number2 = ''

  loop do
    messages('second_num', lang)
    number2 = Kernel.gets().chomp()

    if valid_number?(number2)
      break
    else
      messages('valid_number', lang)
    end
  end

  if lang == 'es'
    operator_prompt = <<-MSG
      ¿Que operacion quiere hacer?
      1) añadir
      2) sustraer
      3) multiplicar
      4) dividir
    MSG
  else
    operator_prompt = <<-MSG
      What operation would you like to perform?
      1) add
      2) subtract
      3) multiply
      4) divide
    MSG
  end

  prompt(operator_prompt)

  operator = ''

  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include?(operator)
      break
    else
      messages('choose', lang)
    end
  end

  result = case operator
           when '1'
             number1.to_f() + number2.to_f()
           when '2'
             number1.to_f() - number2.to_f()
           when '3'
             number1.to_f() * number2.to_f()
           when '4'
             number1.to_f() / number2.to_f()
           end

  if lang == 'es'
    prompt(operacion_a_mensaje(operator))
    prompt("El resultado es #{result}")
  else
    prompt(operation_to_message(operator))
    prompt("The result is #{result}.")
  end

  messages('repeat?', lang)
  answer = Kernel.gets().chomp()
  break unless answer.downcase() == 'y'
end

messages('farewell', lang)
