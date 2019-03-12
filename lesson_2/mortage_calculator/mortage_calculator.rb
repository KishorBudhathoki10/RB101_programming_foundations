require 'yaml'

MESSAGES = YAML.load_file('mortage_calculator.yml')

def prompt(input)
  puts "=> #{input}"
end

def messages(input, lang)
  if lang != 'es'
    lang = 'en'
  end
  prompt(MESSAGES[lang][input])
end

def integer?(input)
  Integer(input) rescue false
end

def float?(input)
  Float(input) rescue false
end

system('clear')

language = <<-MSG
Choose your language:
1) Type 'es' for spanish
2) Type 'en' for english

note: If nothing is typed we will use english as our default language.
MSG

prompt(language)

lang = Kernel.gets().chomp()

messages("welcome", lang)

prompt("------------------------------")

loop do
  messages("loan", lang)
  amount = ''

  loop do
    amount = Kernel.gets().chomp()

    if integer?(amount) && amount.to_i > 0
      break
    else
      messages("error", lang)
    end
  end

  messages("interest_rate", lang)
  messages("example", lang)

  interest_rate = ''
  loop do
    interest_rate = Kernel.gets().chomp()

    if float?(interest_rate) && interest_rate.to_f > 0
      break
    else
      messages("error", lang)
    end
  end

  messages("duration", lang)
  years = ''

  loop do
    years = Kernel.gets().chomp()

    if integer?(years) && years.to_i > 0
      break
    else
      messages("error", lang)
    end
  end

  annual_interest_rate = interest_rate.to_f() / 100
  monthly_interest_rate = annual_interest_rate / 12
  months = years.to_i() * 12

  monthly_payment = amount.to_f *
                    (monthly_interest_rate /
                    (1 - (1 + monthly_interest_rate)**-months))

  if lang == 'es'
    prompt("Su pago mensual es: #{format('%0.2f', monthly_payment)}")
  else
    prompt("Your monthly payment is: #{format('%02.2f', monthly_payment)}")
  end

  messages("repeat", lang)
  answer = Kernel.gets().chomp()

  break unless answer.downcase() == 'y'
end

messages("farewell", lang)
