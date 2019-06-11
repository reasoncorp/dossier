module Dossier
  module Formatter
    include ActiveSupport::Inflector
    include ActionView::Helpers::NumberHelper
    extend self

    def number_to_currency_from_cents(value)
      number_to_currency(value /= 100.0)
    end

    def number_to_dollars(value)
      commafy_number(value, 2).sub(/(\d)/, '$\1')
    end

    def commafy_number(value, precision = nil)
      whole, fraction = value.to_s.split('.')
      fraction = "%.#{precision}d" % (BigDecimal("0.#{fraction || 0}").round(precision) * 10**precision).to_i if precision
      [whole.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,"), fraction].compact.join('.')
    end

    def url_formatter
      @url_formatter ||= UrlFormatter.new
    end

    def report_name(report)
      titleize("#{report.report_name.split('/').last} Report")
    end

    # TODO figure out how to handle this better
    # reports rendered with a system layout use this link_to instead of the
    # correct one
    # delegate :url_for, :link_to, :url_helpers, to: :url_formatter

    class UrlFormatter
      include ActionView::Helpers::UrlHelper

      include ActionDispatch::Routing::UrlFor if defined?(ActionDispatch::Routing::UrlFor) # Rails 4.1
      include ActionView::RoutingUrlFor       if defined?(ActionView::RoutingUrlFor)       # Rails 4.1

      def _routes
        Rails.application.routes
      end

      # No controller in current context, must be specified when generating routes
      def controller
      end

      def url_helpers
        _routes.url_helpers
      end
    end
  end
end
