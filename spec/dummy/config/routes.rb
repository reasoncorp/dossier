Rails.application.routes.draw do
  mount Dossier::Engine => "/dossier"

  get 'woo' => 'site#index', as: 'woo'
end
