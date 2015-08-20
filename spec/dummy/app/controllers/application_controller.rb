ApplicationController = Class.new(ActionController::Base) do
  protect_from_forgery with: :exception
end
