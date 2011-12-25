require 'spec_helper'

describe "questions/edit.html.haml" do

  fixtures :questions

  before :each do
    @original_cat = questions( :cat )
    @cat = questions( :cat )
    @cat.animal = nil
    assign :original_question, @original_cat
    assign :question, @cat
  end

  it 'should ask the correct animal' do
    render

    rendered.             should     include 'What animal was it?'
  end

end
