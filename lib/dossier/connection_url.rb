require 'cgi'
require 'uri'

module Dossier
  class ConnectionUrl

    attr_reader :uri

    def initialize(url = nil)
      @uri = URI.parse(url || ENV.fetch('DATABASE_URL'))
    end
  
    def to_hash
      query = uri.query ? CGI.parse(uri.query) : nil
      adapter = uri.scheme == "postgres" ? "postgresql" : uri.scheme
      {
        adapter:  adapter,
        host:     uri.host,
        database: File.basename(uri.path),
        port:     uri.port,
        user:     uri.user,
        password: uri.password,
        encoding: query && query['encoding'] ? query['encoding'][0] : nil,
        pool: query && query['pool'] ? query['pool'][0].to_i : nil
      }.delete_if{|k,v| v.nil? }
    end

  end
end
