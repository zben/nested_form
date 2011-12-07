require 'nested_form/railtie' if defined?(::Rails)

module NestedForm
  extend ActiveSupport::Autoload

  autoload :Builders
  autoload :Helpers
end