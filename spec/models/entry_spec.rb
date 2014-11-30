require 'spec_helper'

describe Entry do
  it { should respond_to :started_at }
  it { should respond_to :finished_at }
  it { should respond_to :url }

  it { should belong_to :project }

  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    assuming_a_container('/Users/John/Code')
    entry = create_an_entry_with_url('/Users/John/Code/rails/lib/rails/main.rb')
    expect(entry.project).to be_present
    expect(entry.project.url).to eq('/Users/John/Code/rails')
    expect(entry.project.name).to eq('rails')
  end

  it 'when file is within a project directory in the container it assigns a project' do
    assuming_a_container('/Users/John/Code')
    entry = create_an_entry_with_url('/Users/John/Code/rails/Gemfile')
    expect(entry.project).to be_present
    expect(entry.project.url).to eq('/Users/John/Code/rails')
    expect(entry.project.name).to eq('rails')
  end

  it 'when file is in the container it doesnt assign any project' do
    assuming_a_container('/Users/John/Code')
    entry = create_an_entry_with_url('/Users/John/Code/README.md')
    expect(entry.project).to be_nil
  end

  it 'when entry is outside a container it doesnt assign it to a project' do
    assuming_a_container('/Users/John/Code')
    entry = create_an_entry_with_url('/Users/John/.vimrc')
    expect(entry.project).to be_nil
  end

  
end

def create_an_entry_with_url(url)
  entry_attrs = FactoryGirl.attributes_for(:entry)
  Entry.create_with_project(entry_attrs.merge(url: url))
end

def assuming_a_container(path)
  FactoryGirl.create(:container, url: path)
end
