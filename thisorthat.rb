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

  def initialize
    @game_selection = LANGUAGES.sample(5).concat(COCKTAILS.sample(5)).shuffle
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

  puts
  if game.submit_answer(turn, answer)
    puts pastel.green('Correct!')
    game.increment_score(1)
  else
    puts pastel.red('Nope!')
  end

  sleep 2
end

# Final score
system 'clear'
puts pastel.magenta(font.write("Congratulations!"))
sleep 1.5
puts pastel.magenta(font.write("You got..."))
sleep 2
puts pastel.green(font.write("#{game.score}   correct!"))
