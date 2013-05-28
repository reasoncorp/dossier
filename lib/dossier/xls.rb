module Dossier
  class Xls

    HEADER = %Q{<?xml version="1.0" encoding="UTF-8"?>\n<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">\n<Worksheet ss:Name="Sheet1">\n<Table>\n}
    FOOTER = %Q{</Table>\n</Worksheet>\n</Workbook>\n}

    def initialize(collection, headers = nil)
      @headers    = headers || collection.shift
      @collection = collection
    end

    def each
      yield HEADER
      yield headers_as_row
      @collection.each { |record| yield as_row(record) }
      yield FOOTER
    end

    private

    def as_cell(el)
      %{<Cell><Data ss:Type="String">#{el}</Data></Cell>}
    end

    def as_row(array)
      my_array = array.map{|a| as_cell(a)}.join("\n")
      "<Row>\n" + my_array + "\n</Row>\n"
    end

    def headers_as_row
      as_row(@headers.map { |header| Dossier::Formatter.titleize(header) })
    end
  end
end
