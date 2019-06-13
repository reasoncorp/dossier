ApplicationController = Class.new(ActionController::Base)
ApplicationController.protect_from_forgery with: :exception
