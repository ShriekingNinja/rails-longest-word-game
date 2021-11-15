require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = []
    10.times { @grid << [*('A'..'Z')].sample }
    @start_time = Time.now
  end

  def check_word?(word, grid)
    word.upcase.chars.all? { |letter| grid.count(letter) >= word.upcase.count(letter) }
  end

  def english_word?(word)
    full_url = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    url_word = JSON.parse(full_url)
    url_word['found']
  end

  def score
    @word = params[:word]
    @end_time = Time.now
    @start_time = params[:start_time].to_datetime
    @grid = params[:grid]
    @included = check_word?(@word, @grid)
    @english_word = english_word?(@word)

    @player_time = @end_time - @start_time
    @player_score = @word.length + 10 - @player_time.to_i
  end
end
