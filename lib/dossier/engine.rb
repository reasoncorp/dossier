require 'rails'
require 'haml'

module Dossier
  class Engine < ::Rails::Engine
    isolate_namespace Dossier
  end
end
