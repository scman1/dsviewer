Rails.application.routes.draw do
  resources :credentials
  resources :dsdata, :id => /[A-Za-z0-9\.]+/
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
