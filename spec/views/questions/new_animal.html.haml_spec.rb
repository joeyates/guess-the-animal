require 'spec_helper'

describe "questions/new_animal.html.haml" do

  fixtures :questions

  before :each do
    @original_cat = questions( :cat )
    @cat          = questions( :cat )
    @cat.animal   = 'Dog'
    assign :original_question, @original_cat
    assign :question, @cat
  end

  it 'should ask for the correct animal' do
    render

    rendered.             should     include "What question should I ask to tell the difference between a Dog and a #{ questions( :cat ).animal }?"
  end

end
