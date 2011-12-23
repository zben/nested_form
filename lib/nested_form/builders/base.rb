module NestedForm
  module Builders
    module Base
      extend ActiveSupport::Concern

      included do
        class_attribute :wrapper_tags, :wrapper_options
        self.wrapper_tags = HashWithIndifferentAccess.new
        self.wrapper_options = HashWithIndifferentAccess.new
        self.wrapper_options.default = {}

        wrap :add_button, :div, {:class => 'nested-form button add'}        
        wrap :remove_button, :div, {:class => 'nested-form button remove'}
        wrap :inputs, :div, {:class => 'nested-form inputs'}
        wrap :blueprint, :div, {:style => 'display:none'}
      end

      module ClassMethods
        def wrap(item, tag, options={})
          self.wrapper_tags[item] = tag
          self.wrapper_options[item] = options.merge(self.wrapper_options[item])
        end
      end

      attr_reader :template

      def button_to_add(association, *args, &block)
        template.after_nested_form(association) { blueprint(association) }
        
        options = args.extract_options!.merge({:"data-association" => association})
        wrap(:add_button, *(args << options), &block)
      end

      def button_to_remove(*args, &block)        
        wrap(:remove_button, *args, &block)
      end

      def fields_for_with_nested_attributes(association_name, association, options, block)
        # TODO Test this better
        block ||= lambda {|builder| template.render("#{association_name.to_s.singularize}_inputs", :f => builder) }
        @fields ||= {}
        @fields[association_name] = block
        super
      end

      def fields_for_nested_model(name, object, options, block)
        wrap(:inputs) { super }
      end

      def content_tag(tag, content, options)
        if tag.nil?
          content
        else
          template.content_tag(tag, content, options)
        end
      end

      protected

        def wrap(item, content={}, options={}, &block)
          if block_given?
            options = content
            content = block.call
          end

          default_wrapper = self.wrapper_options[item]
          wrapper = options.delete(:wrapper) || {}
          wrapper[:class] = "#{default_wrapper[:class]} #{wrapper[:class]}".strip.presence
          wrapper.reverse_merge!(default_wrapper.symbolize_keys)

          content_tag(self.wrapper_tags[item], send("#{item}_content", content, options), wrapper)
        end

        def add_button_content(content, options)
          content_tag(:button, content, options.reverse_merge(:type => 'button'))
        end

        def remove_button_content(content, options)
          hidden_field(:_destroy) + content_tag(:button, content, options.reverse_merge(:type => 'button'))
        end

        def inputs_content(content, options)
          content
        end

        def blueprint_content(association, options)
          @fields ||= {}
          new_record = object.class.reflect_on_association(association).klass.new
          fields_for(association, new_record, :child_index => "new_#{association}", &@fields[association])
        end

        def blueprint(association)         
          wrap(:blueprint, association, {:wrapper => {:id => "#{association}_blueprint"}})
        end
    end
  end
end
