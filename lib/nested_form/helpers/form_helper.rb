module NestedForm
  module Helpers
    module FormHelper
      def nested_form_for(record, *args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::Builders::FormBuilder)
        form_for(record, *(args << options), &block) << after_nested_form_callbacks
      end

      def after_nested_form(association, &block)
        @associations ||= []
        @after_nested_form_callbacks ||= []
        unless @associations.include?(association)
          @associations << association
          @after_nested_form_callbacks << block
        end
      end

      private
        def after_nested_form_callbacks
          @after_nested_form_callbacks ||= []
          fields = @after_nested_form_callbacks.map(&:call)
          fields.join(" ").html_safe
        end
    end
  end
end
