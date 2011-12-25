require 'spec_helper'

describe "questions/show.html.haml" do

  fixtures :questions

  context 'non-final question' do

    before :each do
      @root = questions( :root )
      assign :question, @root
    end

    it 'should ask a question' do
      render

      rendered.             should     include @root.phrase
    end

    it 'should link to yes question' do
      render

      rendered.             should     include link_to( 'Yes', @root.yes )
    end

    it 'should link to no question' do
      render

      rendered.             should     include link_to( 'No', @root.no )
    end

  end

  context 'final question' do

    before :each do
      @cat = questions( :cat )
      assign :question, @cat
    end

    it 'should display the answer' do
      render

      rendered.             should     include "I think it's a #{ @cat.animal }"
    end

    it 'should check the answer' do
      render

      rendered.             should     include "Is that correct?"
    end

    it 'should link affirmative answer to play again' do
      render

      rendered.             should     include link_to( 'Yes', url_for( :controller => 'games', :action => :play_again ) )
    end

    it 'should link negative answer to edit' do
      render

      rendered.             should     include link_to( 'No', edit_question_url( @cat ) )
    end

  end

end
