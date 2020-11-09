require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    alphabet += alphabet
    @letters = alphabet.sample(10)
  end

  def check_grid?(attempt, grid)
    attempt.upcase!
    attempt_chars = attempt.split('')
    counter = 0
    attempt_chars.each { |char| counter += 1 if grid.include?(char) }
    counter == attempt_chars.length
  end

  def doubles?(attempt, grid)
    # if a letter appears twice in the attempt but only once in the grid
    attempt_chars = attempt.upcase.chars
    return_value = attempt_chars.find do |letter|
      attempt_chars.count(letter) > grid.count(letter)
    end
    return_value.nil? ? (return_value = false) : (return_value = true)
    return return_value
  end

  def english_word?(attempt)
    base_url = "https://wagon-dictionary.herokuapp.com/"
    word_url = base_url + attempt

    word_file = open(word_url).read
    word = JSON.parse(word_file)

    word['found'] == true
  end

  def end
    reset_session
    session[:score] = 0
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    @score = 0
    if @answer
      if (check_grid?(@answer, @letters) && english_word?(@answer)) && !doubles?(@answer, @letters)
        @result = "Well done #{@answer} was an excellent find!"
        @score += (@answer.length ** 2) + 3
        session[:score] += @score
      elsif !english_word?(@answer)
        @result = "Sorry but #{@answer} is not an English word."
      elsif !check_grid?(@answer, @letters)
        @result = "Sorry but #{@answer} is not in the grid."
      elsif doubles?(@answer, @letters)
        @result = "Sorry but #{@answer} contains more than 1 of the provided letters."
      end
    end
  end
end
