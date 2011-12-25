class GamesController < ApplicationController

  def start
    redirect_to question_url( Question.root )
  end

  def about
  end

  def play_again
    @root = Question.root
  end

end
