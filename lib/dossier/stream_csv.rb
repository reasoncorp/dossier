require 'csv'

module Dossier
  class StreamCSV
    attr_reader :headers, :collection

    def initialize(collection, headers = nil)
      @headers    = headers || collection.shift unless false === headers
      @collection = collection
    end

    def each
      yield headers.map { |header| Dossier::Formatter.titleize(header) }.to_csv if headers?
      collection.each do |record|
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

    private

    def headers?
      headers.present?
    end

  end
end
