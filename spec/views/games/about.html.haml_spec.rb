require 'spec_helper'

describe "games/about.html.haml" do

  it 'should explain about the game' do
    render

    rendered.            should     include 'Written by Joe Yates'
  end

end
