Rails.application.routes.draw do

  match "reports/:report", to: 'dossier/reports#show', as: :dossier_report, via: :get
  get   "multi/reports/:report", to: 'dossier/reports#multi', as: :multi_report

end
