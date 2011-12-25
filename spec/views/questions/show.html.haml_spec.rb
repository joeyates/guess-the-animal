require 'spec_helper'

describe "questions/show.html.haml" do

  before :each do
    @question = Question.root
  end

  it 'should ask a question' do
    assign :question, @question

    render

    rendered.             should     contain( @question.phrase )
  end

end
