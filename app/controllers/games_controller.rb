require 'pry-byebug'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Random grid
    alpha = ('A'..'Z').to_a
    # @letters = 10*[A-Z].random
    @letters = 10.times.map { alpha.sample }
  end

  def letter_in_grid(grid, answer)
    answer.chars.all? { |letter| answer.count(letter) <= grid.count(letter) }
  end

  def english_word(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    return word['found']
  end

  def score
    grid = params[:grid]
    answer = params[:word].upcase

    grid_result = letter_in_grid(grid, answer)
    answer_result = english_word(answer)

    if !grid_result
      @result = "Sorry, but #{answer} can’t be built out of #{grid}."
    elsif !answer_result
      @result = "Sorry but #{answer} does not seem to be an English word."
    else
      @result = "Congratulation! #{answer} is a valid English word."
    end
      return @result
  end
end
