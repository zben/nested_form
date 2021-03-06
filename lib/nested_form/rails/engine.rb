module NestedForm
  module Rails
    class Engine < ::Rails::Engine
      initializer 'nested_form' do |app|
        ActiveSupport.on_load(:action_view) do
          include NestedForm::Helpers::FormHelper
          include NestedForm::Helpers::FormtasticFormHelper if defined?(::Formtastic)
          include NestedForm::Helpers::SimpleFormHelper if defined?(::SimpleForm)
        end
      end
    end
  end
end