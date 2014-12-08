require 'spec_helper'

describe Entry do
  it { should respond_to :started_at }
  it { should respond_to :finished_at }
  it { should respond_to :url }
  it { should belong_to :project }
end

def create_an_entry_with_url(url)
  entry_attrs = FactoryGirl.attributes_for(:entry)
  Entry.create_with_project(entry_attrs.merge(url: url))
end

def assuming_a_container(path)
  FactoryGirl.create(:container, url: path)
end
