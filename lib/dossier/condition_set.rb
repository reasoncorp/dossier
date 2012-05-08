require 'set'

module Dossier
  class ConditionSet < ::Set

    attr_accessor :glue

    def glue
      @glue ||= 'and'
    end

    def to_sql
      compact.to_a.map {|c| "(#{c})"}.join(" #{glue} ")
    end

    def to_s
      to_sql
    end

    def compact
      delete_if {|e| e.blank?}
    end

  end
end
