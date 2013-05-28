module Cats
  module Are
    class SuperFunReport < Dossier::Report
      def sql
        "select 'cats', 'are', 'super', 'fun'"
      end
    end
  end
end
