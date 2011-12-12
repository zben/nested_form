require 'spec_helper'

describe NestedForm::Builders::FormtasticFormBuilder do
  it_behaves_like "a nested form builder" do
    let(:builder) { NestedForm::Builders::FormtasticFormBuilder }

    let(:add_button_wrapper) { :li }
    let(:remove_button_wrapper) { :li }
    let(:inputs_wrapper) { :li }
    let(:blueprint_wrapper) { :ol }

    describe "#inputs" do
      before { subject.instance_variable_set(:@already_in_an_inputs_block, true) }

      context "when for is given" do
        it "doesn't wrap output" do
          subject.stubs(:inputs_for_nested_attributes).returns('inputs')
          subject.inputs(:for => :tasks).should == 'inputs'
        end
      end

      context "when for is not given" do
        it "still wraps output" do
          subject.stubs(:field_set_and_list_wrapping).returns('inputs')
          subject.inputs{}.should == '<li class="input">inputs</li>'
        end
      end
    end
  end
end 