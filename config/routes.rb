Rails.application.routes.draw do

  match "reports/:report", :to => 'dossier/reports#show', :as => :dossier_report, via: :get

end
