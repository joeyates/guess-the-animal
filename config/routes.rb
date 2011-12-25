GuessTheAnimal::Application.routes.draw do
  root :to => 'games#start'

  resources :questions do
    member do
      post :new_animal
      post :phrase
    end
  end

  resources :games, :only => [] do
    collection do
      get :about
      get :play_again
    end
  end
end
