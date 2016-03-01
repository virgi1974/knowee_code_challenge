Rails.application.routes.draw do
  resources :users do
    collection { post :load_file }
  end

  root 'users#index' 
  get '/csv' => 'users#read_from_csv'
  post '/excell' => 'users#load_file'

end
