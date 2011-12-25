class QuestionsController < ApplicationController

  def show
    @question = Question.find( params[ :id ] )
  end

  def edit
    @original_question = Question.find( params[ :id ] )
    redirect_to( question_url( @original_question ) ) and return unless @original_question.final?

    @question = Question.find( params[ :id ] )
    @question.animal = nil
  end

  def new_animal
    @original_question = Question.find( params[ :id ] )
    redirect_to( question_url( @original_question ) ) and return unless @original_question.final?

    @question = Question.find( params[ :id ] )
    @question.animal = params[ :question ][ :animal ]
  end

  def phrase
    @question = Question.find( params[ :id ] )
    redirect_to( question_url( @question ) ) and return unless @question.final?

    @question.insert_question( params[ :question ][ :phrase ], params[ :question ][ :animal ] )
    redirect_to url_for( :controller => 'games', :action => :play_again )
  end

end
