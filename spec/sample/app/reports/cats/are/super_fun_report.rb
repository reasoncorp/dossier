module Cats
  module Are
    class SuperFunReport < Dossier::Report
      def sql
        "select #{selections.join(', ')}"
      end

      def selections
        columns = %w(cats are super fun)
        selections = columns.map { |x| "'#{x}' as #{x}" }
        if ENV['DOSSIER_DB'].to_s === 'postgresql'
          selections.map! { |x| 
            parts = x.split(' as ')
            "'#{parts[0][1..-2]}'::character(7) as #{parts[1]}" 
          }
        end
        selections
      end
    end
  end
end
