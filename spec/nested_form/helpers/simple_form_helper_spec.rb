require 'spec_helper'

describe NestedForm::Helpers::SimpleFormHelper do
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    _routes.draw do
      resources :projects
    end
  end

  describe "#simple_nested_form_for" do
    it "delegates to form_for" do
      _view.expects(:simple_form_for).with(:first, :as => :second, :other => :arg, :builder => NestedForm::Builders::SimpleFormBuilder).returns("")
      _view.simple_nested_form_for(:first, :as => :second, :other => :arg) {}
    end

    it "passes the correct form builder to its block" do
      _view.simple_nested_form_for(Project.new) do |f|
        f.should be_a(NestedForm::Builders::SimpleFormBuilder)
      end
    end

    it "appends content after nested form" do
      _view.after_nested_form(:tasks) { _view.concat("123") }
      _view.after_nested_form(:milestones) { _view.concat("456") }
      _view.simple_nested_form_for(Project.new) {}
      _view.output_buffer.should include("123456")
    end
  end
end

