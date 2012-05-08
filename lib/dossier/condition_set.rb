require 'set'

module Dossier
  class ConditionSet < Set

    def to_s
      self.to_a.join
    end

  end
end
