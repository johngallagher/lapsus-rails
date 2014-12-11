require 'spec_helper'

describe Entry do
  it { should respond_to :started_at }
  it { should respond_to :finished_at }
  it { should respond_to :url }
  it { should belong_to :project }
  it { should validate_presence_of :started_at}
  it { should validate_presence_of :finished_at }
  it { should validate_presence_of :url }
  it { should allow_value('file://User/John', 'http://www.google.com').for(:url) }
  it { should_not allow_value('User', 'hello').for(:url) }

  it 'calculates duration' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    expect(entry.duration).to eq(3600)
  end

  it 'with no project it returns none' do
    expect(create_entry.project_name).to eq('None')
  end

  it 'with a project it returns the project name' do
    project = create_project(name: 'John')
    entry = create_entry(project_id: project.id)
    expect(entry.project_name).to eq('John')
  end
end

def create_project(attrs={})
  defaults = { name: 'John', url: 'file:///Users/John' }
  Project.create(defaults.merge(attrs))
end

def create_entry(attrs={})
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00', url: 'file:///Users/John'}
  Entry.create(defaults.merge(attrs))
end
