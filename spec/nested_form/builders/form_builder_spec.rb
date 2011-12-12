require 'spec_helper'

describe NestedForm::Builders::FormBuilder do
  it_behaves_like "a nested form builder" do
    let(:builder) { NestedForm::Builders::FormBuilder }

    let(:add_button_wrapper) { :div }
    let(:remove_button_wrapper) { :div }
    let(:inputs_wrapper) { :div }
    let(:blueprint_wrapper) { :div }
  end
end 