require 'uri'
require 'rack/utils'

module Dossier
  class ConnectionUrl

    attr_reader :uri

    def initialize(url = nil)
      @uri = URI.parse(url || ENV.fetch('DATABASE_URL'))
    end

    def to_hash
      {
        adapter:  adapter,
        username: uri.user,
        password: uri.password,
        host:     uri.host,
        port:     uri.port,
        database: database_name
      }.merge(params).reject { |k,v| v.nil? }
    end

    private

    def adapter
      uri.scheme == "postgres" ? "postgresql" : uri.scheme
    end

    def params
      return {} unless uri.query
      Rack::Utils.parse_nested_query(uri.query).symbolize_keys
    end

    def database_name
      path = File.basename(uri.path)
      if path.blank? || path == "/"
        nil
      else
        path
      end
    end
  end
end
