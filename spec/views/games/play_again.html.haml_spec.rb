require 'spec_helper'

describe "games/play_again.html.haml" do

  fixtures :questions

  before :each do
    assign :root, questions( :root )
  end

  it 'should ask if you want to play again' do
    render

    rendered.            should     include 'Play again?'
  end

  it 'should link affirmative answer to root question' do
    render

    rendered.             should     include link_to( 'Yes', questions( :root ) )
  end

end
