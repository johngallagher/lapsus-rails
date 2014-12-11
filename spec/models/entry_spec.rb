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

  xit 'doesnt allow overlapping times' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    duplicate_entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    expect(entry).to be_valid
    expect(duplicate_entry).to be_invalid
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
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:00:00')
    new_entry = new_entry(started_at: '2014-01-01 15:00:00', finished_at:  '2014-01-01 16:00:00')
    expect(new_entry.overlapping_entries).to eq([])
  end

  # 14:00       15:00       16:00
  #   | new_entry |
  #               |    entry  |
  it 'when new entry is before entry it doesnt show any overlapping entries' do
    entry = create_entry(started_at: '2014-01-01 15:00:00', finished_at:  '2014-01-01 16:00:00')
    new_entry = new_entry(started_at: '2014-01-01 14:00:00', finished_at:  '2014-01-01 15:00:00')
    expect(new_entry.overlapping_entries).to eq([])
  end

  it 'calculates duration' do
    entry = create_entry(started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00')
    expect(entry.duration).to eq(3600)
  end

  it 'returns possible container urls' do
    entry = create_entry(url: 'file:///Users/John/Code/lapsus/main.rb')
    expect(entry.possible_container_urls).to eq(['file:///Users', 'file:///Users/John', 'file:///Users/John/Code'])
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

def new_entry(attrs={})
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00', url: 'file:///Users/John'}
  Entry.new(defaults.merge(attrs))
end
def create_entry(attrs={})
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00', url: 'file:///Users/John'}
  Entry.create(defaults.merge(attrs))
end
