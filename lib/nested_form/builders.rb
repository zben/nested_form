module NestedForm
  module Builders
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :FormBuilder
    autoload :SimpleFormBuilder if defined?(::SimpleForm)
    autoload :FormtasticFormBuilder if defined?(::Formtastic)
  end
end