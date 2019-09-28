Rails.application.routes.draw do
    root 'specimens#index'
    resources :specimens, :id => /[A-Za-z0-9\.\_]+/
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
