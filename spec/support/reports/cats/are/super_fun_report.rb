module Cats
  module Are
    class SuperFunReport < Dossier::Report
      def sql
        "select * from cats where fun = true" # Doesn't matter; not meant to be run.
      end
    end
  end
end
