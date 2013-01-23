require 'csv'

module Dossier
  class StreamCSV

    def initialize(collection, headers = nil)
      @headers    = headers || collection.shift
      @collection = collection
    end

    def each
      yield @headers.map { |header| Dossier::Formatter.titleize(header) }.to_csv
      @collection.each do |record|
        yield record.to_csv
      end
    rescue => e
      if Rails.application.config.consider_all_requests_local
        yield e.message
        e.backtrace.each do |line|
          yield "#{line}\n"
        end
      else
        yield "We're sorry, but something went wrong." 
      end
    end

  end
end
