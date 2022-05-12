#!/usr/bin/env ruby

require 'tty-prompt'
require 'tty-font'
require 'pastel'

# TODO
# - Make the class take a config object that provides
#   - The two lists
#   - the number of turns
# - Move the class out of this file
class ThisOrThatGame
  LANGUAGES = %w[Snowball Babbage Ballerina Boomerang Charm
                 Clipper Cyclone Draco Elixer Euphoria Phantom Magma]

  COCKTAILS = ['Bramble', 'Aviation', 'Pegu', 'Tuxedo', 'Zombie', 'Vesper',
            'Woo Woo', 'Cloister', 'Hoppel Poppel', 'Blackthorn', 'Gunfire',
            'Test Pilot']

  attr_reader :score

  def initialize(question_count = 10)
    raise "Not enough list items to support that many questions" if question_count > 24

    @question_count = question_count.even? ? question_count : question_count - 1
    @game_selection = LANGUAGES.sample(question_count/2).concat(COCKTAILS.sample(question_count/2)).shuffle
    @score = 0
  end

  def get_turn
    return @game_selection.shift
  end

  def submit_answer(item, guess)
    if guess == 'language'
      return LANGUAGES.include? item
    else
      return COCKTAILS.include? item
    end
  end

  def increment_score(amount)
    @score += amount
  end
end

def flash(font, pastel, text, color = 'white')
  system 'clear'
  puts pastel.send(color, font.write(text))
  sleep 0.5
  system 'clear'
  sleep 0.2
  puts pastel.send(color, font.write(text))
  sleep 0.5
  system 'clear'
  sleep 0.2
  puts pastel.send(color, font.write(text))
  sleep 0.5
end

game = ThisOrThatGame.new
answers = [
  { name: 'Programming Language', value: 'language' },
  { name: 'Cocktail', value: 'cocktail' }
]

prompt = TTY::Prompt.new(interrupt: :exit)
font = TTY::Font.new(:standard)
pastel = Pastel.new

# Title
system 'clear'
puts pastel.green(font.write("Language"))
sleep 0.5
puts font.write("-or-")
sleep 0.5
puts pastel.magenta(font.write("Cocktail?"))
puts
puts
prompt.keypress("Press space to start", keys: [:space])

# Present the questions
loop do
  turn = game.get_turn

  break if turn.nil?

  system 'clear'
  answer = prompt.select(font.write(turn), answers)

  success_text = ['Correct!', 'Good  Job!', 'Yup!', 'Way  to  go!']
  fail_text = ['Nope!', 'Wrong!', 'So  Close!', 'Not  Quite!']
  if game.submit_answer(turn, answer)
    flash(font, pastel, success_text.sample, 'green')
    game.increment_score(1)
  else
    flash(font, pastel, fail_text.sample, 'red')
  end
end

# Final score
system 'clear'
puts pastel.magenta(font.write("Congratulations!"))
sleep 1.5
puts pastel.magenta(font.write("You got..."))
sleep 2
puts pastel.green(font.write("#{game.score}   correct!"))
