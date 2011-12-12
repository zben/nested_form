require 'spec_helper'

describe NestedForm::Builders::SimpleFormBuilder do
  it_behaves_like "a nested form builder" do
    let(:builder) { NestedForm::Builders::SimpleFormBuilder }

    let(:add_button_wrapper) { :div }
    let(:remove_button_wrapper) { :div }
    let(:inputs_wrapper) { :div }
    let(:blueprint_wrapper) { :div }
  end
end 