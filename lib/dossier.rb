require "dossier/engine"
require "dossier/version"

module Dossier

  def self.client
    @client ||= Mysql2::Client.new
  end

end

require "dossier/condition"
require "dossier/condition_set"
require "dossier/report"
