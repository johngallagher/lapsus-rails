require 'spec_helper'

describe Entry do
  it { should respond_to :started_at }
  it { should respond_to :finished_at }
  it { should respond_to :path }
  it { should respond_to :url }
  it { should respond_to :application_bundle_id }
  it { should respond_to :application_name }

  it { should belong_to :project }

  it { should validate_presence_of :started_at}
  it { should validate_presence_of :finished_at }

  it 'should not allow absolute urls without a path' do
    expect(new_entry(url: 'file://')).to be_invalid
  end

  it 'allows url to be blank' do
    expect(new_entry(url: '')).to be_valid
  end

  it 'can be untrained' do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project) 
    entry = FactoryGirl.create(:entry, project: project, user: user)

    expect(entry.project).to eq(project)
    entry.untrain
    expect(entry.project).to eq(user.none_project)
  end

  it 'calculates the path from the url on new' do
    expect(new_entry(url: 'file://localhost/Users/John').path).to eq('/Users/John')
    expect(new_entry(url: 'file:///Users/John').path).to eq('/Users/John')
    expect(new_entry(url: 'http://www.google.co.uk/search?q=hello').path).to eq('/search')
    expect(new_entry(url: nil).path).to eq('')
    expect(new_entry(url: '').path).to eq('')
  end

  xit 'marks overlapping entries as invalid' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    duplicate_entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    expect(entry).to be_valid
    expect(duplicate_entry).to be_invalid
    expect(duplicate_entry.errors.full_messages.first).to include('overlap')
  end

  # 14:00       15:00       16:00
  #               | entry  |
  #   | new_entry  |
  #                ^
  #                new_entry overlaps start of entry
  it 'returns existing entries that the new entry overlaps the start of' do
    entry = create_entry(started_at: '2014-01-01 15:00:00', finished_at:  '2014-01-01 16:00:00')
    new_entry = new_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:00:01')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #   |         entry   |      
  #   |       new_entry       | 
  #              ^
  #              existing entry overlaps first half of the new entry
  it 'returns existing entries that overlap the first half of the new entry' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:30:00')
    new_entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #       |     entry         |
  #   |       new_entry       | 
  #              ^
  #              existing entry overlaps last half of the new entry
  it 'returns existing entries that overlap the last half of the new entry' do
    entry = create_entry(started_at: '2014-01-01 14:30:00', finished_at:  '2014-01-01 16:00:00')
    new_entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #   |         entry         |
  #   |       new_entry       | 
  #              ^
  #              existing entry exactly overlaps the new entry
  it 'returns existing entries that exactly overlap the new entry' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 16:00:00')
    new_entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #   |         entry         |
  #         | new_entry  |
  #              ^
  #              existing entry is outside the new entry
  it 'returns existing entries that are outside the new entry' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 16:00:00')
    new_entry = new_entry(started_at: '2014-01-01 14:30:00', finished_at:  '2014-01-01 15:30:00')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #         |   entry   |
  #   |        new_entry      |
  #              ^
  #              existing entry is inside the new entry
  it 'returns existing entries that are inside the new entry' do
    entry = create_entry(started_at: '2014-01-01 14:30:00', finished_at:  '2014-01-01 15:30:00')
    new_entry = new_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #   |   entry   |
  #              | new_entry  |
  #              ^
  #              new_entry overlaps end of entry
  it 'returns existing entries that the new entry overlaps the end of' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:00:00')
    new_entry = new_entry(started_at: '2014-01-01 14:59:59', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([entry])
  end

  # 14:00       15:00       16:00
  #   |   entry   |
  #               | new_entry |
  it 'when new entry is after entry it doesnt show any overlapping entries' do
    create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:00:00')
    new_entry = new_entry(started_at: '2014-01-01 15:00:00', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([])
  end

  # 14:00       15:00       16:00
  #   | new_entry |
  #               |    entry  |
  it 'when new entry is before entry it doesnt show any overlapping entries' do
    create_entry(started_at: '2014-01-01 15:00:00', finished_at:  '2014-01-01 16:00:00')
    new_entry = new_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:00:00')
    expect(new_entry.overlapping_entries).to eq([])
  end

  it 'calculates duration' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    expect(entry.duration).to eq(3600)
  end

  it 'with a project it returns the project name' do
    project = create_project(name: 'John')
    entry = create_entry(project_id: project.id)
    expect(entry.project.name).to eq('John')
  end
end

def create_project(attrs={})
  defaults = { name: 'John', path: '/Users/John' }
  Project.create(defaults.merge(attrs))
end

def new_entry(attrs={})
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00'}
  Entry.new(defaults.merge(attrs))
end

def new_entry(attrs={})
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00'}
  Entry.new(defaults.merge(attrs))
end

def create_entry(attrs={})
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00'}
  Entry.create(defaults.merge(attrs))
end

def assuming_a_container(path)
  Container.create(name: 'Code', path: path)
end
