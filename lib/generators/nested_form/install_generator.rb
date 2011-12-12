module NestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def copy_javascripts
        copy_file 'jquery_nested_form.js.coffee', 'public/javascripts/nested_form.js.coffee'
      end
    end
  end
end
