module Dossier
  class Condition

    def initialize(fragment, binds = {})
      @fragment = fragment
      @binds    = binds
    end

    def to_sql
      return @fragment if @binds.empty?
      @binds.reduce(@fragment) do |bound, (key, value)|
        bound.gsub(":#{key}") { escape(value) }
      end
    end

    def to_s
      to_sql
    end

    def blank?
      @fragment.blank?
    end

    private

    def escape(value)
      case value
      when Array
        value.map { |v| escape(v) }.join(',')
      when Fixnum
        value
      when String
        "'#{Dossier.client.escape(value)}'"
      else
        raise ArgumentError.new("bound values may only be an Array, String, or Fixnum; you provided a #{value.class} (#{value.inspect}).")
      end
    end

  end
end
