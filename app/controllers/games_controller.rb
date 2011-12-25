class GamesController < ApplicationController

  def about
  end

  def play_again
    @root = Question.root
  end

end
