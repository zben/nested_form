$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bundler/setup'
require 'rails'
require 'action_view/railtie'
Bundler.require(:default)
require 'action_controller/railtie'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false

# a fake app for initializing the railtie
app = Class.new(Rails::Application)
app.config.secret_token = "token"
app.config.session_store :cookie_store, :key => "_myapp_session"
app.config.active_support.deprecation = :log
app.config.action_controller.perform_caching = false
app.initialize!

require 'rspec/rails'
RSpec.configure do |config|
  config.mock_with :mocha
end

ActiveRecord::Schema.define do
  create_table :projects, :force => true do |t|
    t.string :name
  end
end
class Project < ActiveRecord::Base
  # column :name, :string
  has_many :tasks
  accepts_nested_attributes_for :tasks
end

ActiveRecord::Schema.define do
  create_table :tasks, :force => true do |t|
    t.integer :project_id
    t.string :name
  end
end
class Task < ActiveRecord::Base
  # column :project_id, :integer
  # column :name, :string
  belongs_to :project
end

ActiveRecord::Schema.define do
  create_table :milestones, :force => true do |t|
    t.integer :task_id
    t.string :name
  end
end
class Milestone < ActiveRecord::Base
  # column :task_id, :integer
  # column :name, :string
  belongs_to :task
end

shared_examples_for "a nested form builder" do
  subject { builder.new(:item, project, template, options, lambda {}) }

  let(:project) { Project.new }
  let(:template) { ActionView::Base.new }

  before { template.output_buffer = ""}

  let(:options) { {} }
  
  describe "with no options" do
    describe "#button_to_add" do
      it "is wrapped in .nested-form.button.add" do
        subject.button_to_add(:tasks, "Add").should =~ %r{<#{add_button_wrapper} class="nested-form button add">.+</#{add_button_wrapper}>}
      end

      it "contains a button" do
        subject.button_to_add(:tasks, "Add").should =~ %r{<button data-association="tasks" type="button">Add</button>}
      end

      it "takes options for the button" do
        subject.button_to_add(:tasks, "Add", :class => "foo").should =~ %r{<button class="foo" data-association="tasks" type="button">Add</button>}
      end

      it "takes a block for content" do
        subject.button_to_add(:tasks, :class => "foo") { "Add" }.should =~ %r{<button class="foo" data-association="tasks" type="button">Add</button>}
      end

      it "adds blueprint after form" do
        subject.button_to_add(:tasks, "Add")
        template.stubs(:render).returns 'task_fields'
        template.send(:after_nested_form_callbacks).should == %Q(<#{blueprint_wrapper} id="tasks_blueprint" style="display:none"><#{inputs_wrapper} class="nested-form inputs">task_fields</#{inputs_wrapper}></#{blueprint_wrapper}>)
      end
    end

    describe "#button_to_remove" do
      it "is wrapped in .nested-form.button.remove" do
        subject.button_to_remove("Remove").should =~ %r{<#{remove_button_wrapper} class="nested-form button remove">.+</#{remove_button_wrapper}>}
      end

      it "contains a button" do
        subject.button_to_remove("Remove").should =~ %r{<button type="button">Remove</button>}
      end

      it "contains a hidden field" do
        subject.button_to_remove("Remove").should =~ %r{<input id="\w+_destroy" name=".+\[_destroy\]" type="hidden" value="false" />}
      end

      it "takes options for the button" do
        subject.button_to_remove("Remove", :class => "foo").should =~ %r{<button class="foo" type="button">Remove</button>}
      end

      it "takes a block for content" do
        subject.button_to_remove(:class => "foo") { "Remove" }.should =~ %r{<button class="foo" type="button">Remove</button>}
      end
    end

    it "wraps nested fields in .nested-form.inputs" do
      2.times { project.tasks.build }
      subject.fields_for(:tasks) { "task_fields" }.should == %Q(<#{inputs_wrapper} class="nested-form inputs">task_fields</#{inputs_wrapper}>) * 2
    end
  end
end
