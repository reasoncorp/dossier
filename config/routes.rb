Dossier::Engine.routes.draw do

  match "reports/:report", :to => 'reports#show'

end
