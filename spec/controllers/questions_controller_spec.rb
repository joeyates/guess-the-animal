require 'spec_helper'

describe QuestionsController do

  fixtures :questions

  before :each do
    @root = questions( :root )
    @cat  = questions( :cat )
  end

  context 'show' do

    before :each do
      get :show, :id => @root.id
    end

    it 'should succeed' do
      response.             should     be_success
      response.             should     render_template( 'questions/show' )
    end

    it 'should load the question' do
      assigns( :question ). should     == @root
    end

  end

  context :edit do

    before :each do
      get :edit, :id => @cat.id
    end

    it 'should succeed for a final question' do
      response.             should     be_success
      response.             should     render_template( 'questions/edit' )
    end

    it 'should fail for a non-final question' do
      get :edit, :id => @root.id

      response.             should     be_redirect # to 'questions#show'
    end

    it 'should load the question unaltered as original_question' do
      assigns( :original_question ).
                            should     == @cat
      assigns( :original_question ).animal.
                            should     == @cat.animal
      assigns( :original_question ).phrase.
                            should     be_blank
    end

    it 'should load the question, clearing the animal as question' do
      assigns( :question ).
                            should     == @cat
      assigns( :question ).animal.
                            should     be_blank
      assigns( :question ).phrase.
                            should     be_blank
    end

  end

  context :new_animal do

    before :each do
      post :new_animal, :id => @cat.id,
                        :question => { :animal => 'Dog' }
    end

    it 'should succeed for a final question' do
      response.             should     be_success
      response.             should     render_template( 'questions/new_animal' )
    end

    it 'should fail for a non-final question' do
      post :new_animal, :id => @root.id

      response.             should     be_redirect # to 'questions#show'
    end

    it 'should load the question unaltered as original_question' do
      assigns( :original_question ).
                            should     == @cat
      assigns( :original_question ).animal.
                            should     == @cat.animal
      assigns( :original_question ).phrase.
                            should     be_blank
    end

    it 'should load the question, setting animal to the supplied value' do
      assigns( :question ). should     == @cat
      assigns( :question ).animal.
                            should     == 'Dog'
    end

  end

  context :phrase do

    before :each do
      post :phrase, :id => @cat.id, :question => { :animal => 'Dog',
                                                   :phrase => 'Does it bark?' }
    end

    it 'should succeed for a final question' do
      response.             should     be_redirect # to 'games/play_again'
    end

    it 'should fail for a non-final question' do
      post :phrase, :id => @root.id

      response.             should     be_redirect # to 'questions#show'
    end

    it 'should update the question to be non-final, using the supplied phrase' do
      question = Question.find( @cat.id )
      dog      = Question.find_by_animal( 'Dog' )
      new_cat  = Question.find_by_animal( 'Cat' )

      question.animal.      should     be_blank
      question.phrase.      should     == 'Does it bark?'
      dog.                  should_not be_nil
      new_cat.              should_not == question
      question.yes.         should     == dog
      question.no.          should     == new_cat
    end

  end

end
