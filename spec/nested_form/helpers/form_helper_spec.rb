require 'spec_helper'

describe NestedForm::Helpers::FormHelper do
  include RSpec::Rails::HelperExampleGroup
  
  before(:each) do
    _routes.draw do
      resources :projects
    end
  end

  it "should pass nested form builder to form_for along with other options" do
    pending
    mock.proxy(_view).form_for(:first, :as => :second, :other => :arg, :builder => NestedForm::Builders::FormBuilder) do |form_html|
      form_html
    end
    _view.nested_form_for(:first, :as => :second, :other => :arg) {"form"}
  end

  it "should pass instance of NestedForm::Builder to nested_form_for block" do
    _view.nested_form_for(Project.new) do |f|
      f.should be_instance_of(NestedForm::Builders::FormBuilder)
    end
  end

  it "should append content to end of nested form" do
    _view.after_nested_form(:tasks) { _view.concat("123") }
    _view.after_nested_form(:milestones) { _view.concat("456") }
    _view.nested_form_for(Project.new) {}
    _view.output_buffer.should include("123456")
  end
end

