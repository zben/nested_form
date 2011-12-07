module NestedForm
  module Helpers
    extend ActiveSupport::Autoload

    autoload :FormHelper
    autoload :SimpleFormHelper if defined?(::SimpleForm)
    autoload :FormtasticFormHelper if defined?(::Formtastic)
  end
end