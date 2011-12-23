require 'nested_form/rails' if defined?(::Rails)

module NestedForm
  extend ActiveSupport::Autoload

  autoload :Builders
  autoload :Helpers
end