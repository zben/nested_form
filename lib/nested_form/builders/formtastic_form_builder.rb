Formtastic::FormBuilder = Formtastic::SemanticFormBuilder unless defined?(Formtastic::FormBuilder)

module NestedForm
  module Builders
    class FormtasticFormBuilder < ::Formtastic::FormBuilder
      include Base
    end  
  end
end