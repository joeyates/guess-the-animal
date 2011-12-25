require 'spec_helper'

describe GamesController do

  context 'play_again' do

    it 'should succeed' do
      get :play_again

      response.             should     be_success
      response.             should     render_template( 'games/play_again' )
    end

  end

end
