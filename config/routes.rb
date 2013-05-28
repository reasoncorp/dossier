Rails.application.routes.draw do

  get   "reports/*report",       to: 'dossier/reports#show',  as: :dossier_report
  get   "multi/reports/*report", to: 'dossier/reports#multi', as: :dossier_multi_report

end
