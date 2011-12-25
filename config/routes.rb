GuessTheAnimal::Application.routes.draw do
  resources :questions

  resources :games, :only => [] do
    collection do
      get :about
      get :play_again
    end
  end
end
