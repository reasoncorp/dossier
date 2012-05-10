require 'csv'

module Dossier
  class StreamCSV

    def initialize(collection)
      @collection = collection
    end

    def each
      @collection.each do |record|
        yield record.to_csv
      end
    rescue => e
      e.backtrace.each do |line|
        yield "#{line}\n"
      end
    end

  end
end
