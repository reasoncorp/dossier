module Dossier
  module Format
    class CurrencyInCents < Currency
      def format
        self.value /= 100.0
        super
      end
    end
  end
end
