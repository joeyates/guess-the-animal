require 'spec_helper'

describe QuestionsController do

  context 'show' do

    before :each do
      @root_question = Question.root
    end

    it 'should succeed' do
      get :show, :id => @root_question.id

      response.             should     be_success
      response.             should     render_template( 'questions/show' )
    end

    it 'should load the question' do
      get :show, :id => @root_question.id

      assigns( :question ). should     == @root_question
    end

  end

end
