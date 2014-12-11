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
    entry = Entry.create(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00', url: 'file:///Users/John')
    expect(entry.duration).to eq(3600)
  end

  it 'with no project it returns none' do
    entry = Entry.create(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00', url: 'file:///Users/John')
    expect(entry.project_name).to eq('None')
  end

  it 'with a project it returns the project name' do
    entry = Entry.create(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00', url: 'file:///Users/John')
    project = Project.create(name: 'John', url: '')
    entry.project = project
    expect(entry.project_name).to eq('John')
  end
end
