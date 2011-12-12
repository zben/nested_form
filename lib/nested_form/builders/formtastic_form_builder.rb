module NestedForm
  module Builders
    class FormtasticFormBuilder < ::Formtastic::FormBuilder
      include Base

      wrap :add_button, :li  
      wrap :remove_button, :li
      wrap :inputs, :li
      wrap :blueprint, :ol

      def inputs(*args, &block)
        wrap_it = @already_in_an_inputs_block

        options = args.extract_options!

        @already_in_an_inputs_block = false if options[:for]

        out = super(*(args << options), &block)

        @already_in_an_inputs_block = wrap_it
        
        out
      end
    end  
  end
end