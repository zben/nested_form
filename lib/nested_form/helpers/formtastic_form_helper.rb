module NestedForm
  module Helpers
    module FormtasticFormHelper
      def semantic_nested_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::Builders::FormtasticFormBuilder)
        semantic_form_for(*(args << options), &block) << after_nested_form_callbacks
      end
    end
  end
end