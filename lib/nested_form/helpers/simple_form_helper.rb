module NestedForm
  module Helpers
    module SimpleFormHelper
      def simple_nested_form_for(record, *args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::Builders::SimpleFormBuilder)
        simple_form_for(record, *(args << options), &block) << after_nested_form_callbacks
      end
    end
  end
end
