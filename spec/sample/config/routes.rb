Rails.application.routes.draw do
  get 'woo' => 'site#index', as: 'woo'
  get 'employee_report_custom_controller' => 'site#report', as: 'employee_report_custom_controller'
end
