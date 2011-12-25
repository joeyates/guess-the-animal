require 'spec_helper'

describe "questions/show.html.haml" do

  fixtures :questions

  before :each do
    @question = Question.root
  end

  it 'should ask a question' do
    render

    rendered.             should     include @question.phrase
  end

  it 'should link to yes question' do
    render

    rendered.             should     include link_to( 'Yes', @question.yes )
  end

  it 'should link to no question' do
    render

    rendered.             should     include link_to( 'No', @question.no )
  end

end
