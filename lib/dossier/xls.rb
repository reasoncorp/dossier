module Dossier
  class Xls

    HEADER = %Q{<?xml version="1.0" encoding="UTF-8"?>\n<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">\n<ss:Styles><ss:Style ss:ID="s22"><NumberFormat ss:Format="yyyy\-mm\-dd hh:mm:ss"/></ss:Style></ss:Styles>\n<Worksheet ss:Name="Sheet1">\n<Table>\n}
    FOOTER = %Q{</Table>\n</Worksheet>\n</Workbook>\n}

    def initialize(user, collection, headers = nil)
      @user = user
      @headers = headers || collection.shift
      @collection = collection
    end

    def each
      yield HEADER
      yield as_row(@headers)
      @collection.each { |record| yield as_row(record) }
      yield FOOTER
    end

    def as_cell(el)
      if el.instance_of? Time
        time_zone = @user.current_hospital.time_zone
        excel_time = el.in_time_zone(time_zone)
        excel_time = excel_time.strftime("%FT%T")
        %{<Cell ss:StyleID="s22"><Data ss:Type="DateTime">#{excel_time}</Data></Cell>}
      else
        %{<Cell><Data ss:Type="String">#{el}</Data></Cell>}
      end
    end

    def as_row(array)
      my_array = array
        .each_with_index
        .select { |x, n| include_column?(n) }.map(&:first)
        .map{|a| as_cell(a)}
        .join("\n")
      "<Row>\n" + my_array + "\n</Row>\n"
    end

    def include_column?(column_index)
      true
    end

  end
end
