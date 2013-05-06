module Dossier
  class ViewsGenerator < Rails::Generators::Base
    desc "This generator creates report views"
    source_root File.expand_path('../templates', __FILE__)
    argument :report_name, type: :string, default: "show" 

    def generate_view
      template "show.html.haml", Rails.root.join("app/" "views/" "dossier/reports/#{report_name}.html.haml")
    end

  end
end
