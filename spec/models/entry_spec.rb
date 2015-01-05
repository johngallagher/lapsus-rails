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

  describe 'entry creation' do
    it 'when started_at or finished_at is blank it returns nil start and end' do
      entries = Entry.new_split_by_hour({ started_at: '', finished_at: '', url: 'url'})
      expect(entries.count).to eq(1)

      expect(entries.first.started_at).to  be_nil
      expect(entries.first.finished_at).to be_nil
      expect(entries.first.url).to         eq('url')
    end

    it 'when started_at or finished_at is nil it returns nil start and end' do
      entries = Entry.new_split_by_hour({ url: 'url'})
      expect(entries.count).to eq(1)

      expect(entries.first.started_at).to  be_nil
      expect(entries.first.finished_at).to be_nil
      expect(entries.first.url).to         eq('url')
    end

    it 'when entry is within an hour boundary it doesnt break it up' do
      entries = Entry.new_split_by_hour({ started_at: '2014-01-01 00:30:00', finished_at: '2014-01-01 00:40:00', url: 'url'})
      expect(entries.count).to eq(1)

      expect(entries.first.started_at).to  eq(Time.zone.parse('2014-01-01 00:30:00'))
      expect(entries.first.finished_at).to eq(Time.zone.parse('2014-01-01 00:40:00'))
      expect(entries.first.url).to         eq('url')
    end

    it 'when entry overlaps an hour boundary break into two separate chunks' do
      entries = Entry.new_split_by_hour({ started_at: '2014-01-01 00:30:00', finished_at: '2014-01-01 01:30:00', url: 'url'})

      expect(entries.count).to eq(2)

      expect(entries.first.started_at).to  eq(Time.zone.parse('2014-01-01 00:30:00'))
      expect(entries.first.finished_at).to eq(Time.zone.parse('2014-01-01 00:30:00').end_of_hour)
      expect(entries.first.url).to         eq('url')

      expect(entries.second.started_at).to  eq(Time.zone.parse('2014-01-01 01:00:00'))
      expect(entries.second.finished_at).to eq(Time.zone.parse('2014-01-01 01:30:00'))
      expect(entries.second.url).to         eq('url')
    end

    it 'when entry overlaps a two hour boundary break into three separate chunks' do
      entries = Entry.new_split_by_hour({ started_at: '2014-01-01 00:30:00', finished_at: '2014-01-01 02:30:00', url: 'url'})

      expect(entries.count).to eq(3)

      expect(entries.first.started_at).to  eq(Time.zone.parse('2014-01-01 00:30:00'))
      expect(entries.first.finished_at).to eq(Time.zone.parse('2014-01-01 00:30:00').end_of_hour)
      expect(entries.first.url).to         eq('url')

      expect(entries.second.started_at).to  eq(Time.zone.parse('2014-01-01 01:00:00'))
      expect(entries.second.finished_at).to eq(Time.zone.parse('2014-01-01 01:00:00').end_of_hour)
      expect(entries.second.url).to         eq('url')

      expect(entries.third.started_at).to  eq(Time.zone.parse('2014-01-01 02:00:00'))
      expect(entries.third.finished_at).to eq(Time.zone.parse('2014-01-01 02:30:00'))
      expect(entries.third.url).to         eq('url')
    end

    it 'when entry overlaps a three hour boundary break into four separate chunks' do
      entries = Entry.new_split_by_hour({ started_at: '2014-01-01 00:30:00', finished_at: '2014-01-01 03:30:00', url: 'url'})

      expect(entries.count).to eq(4)

      expect(entries.first.started_at).to  eq(Time.zone.parse('2014-01-01 00:30:00'))
      expect(entries.first.finished_at).to eq(Time.zone.parse('2014-01-01 00:30:00').end_of_hour)
      expect(entries.first.url).to         eq('url')

      expect(entries.second.started_at).to  eq(Time.zone.parse('2014-01-01 01:00:00'))
      expect(entries.second.finished_at).to eq(Time.zone.parse('2014-01-01 01:00:00').end_of_hour)
      expect(entries.second.url).to         eq('url')

      expect(entries.third.started_at).to  eq(Time.zone.parse('2014-01-01 02:00:00'))
      expect(entries.third.finished_at).to eq(Time.zone.parse('2014-01-01 02:00:00').end_of_hour)
      expect(entries.third.url).to         eq('url')

      expect(entries.fourth.started_at).to  eq(Time.zone.parse('2014-01-01 03:00:00'))
      expect(entries.fourth.finished_at).to eq(Time.zone.parse('2014-01-01 03:30:00'))
      expect(entries.fourth.url).to         eq('url')
    end
  end

  describe 'previous entry' do
    it 'with two entries in the search window it chooses the most recent' do
      entry = FactoryGirl.create(:entry, started_at: 1.second.ago, finished_at: 2.seconds.ago)
      older_entry = FactoryGirl.create(:entry, started_at: 2.second.ago, finished_at: 3.seconds.ago)
      oldest_entry = FactoryGirl.create(:entry, started_at: 3.second.ago, finished_at: 4.seconds.ago)
      expect(entry.previous).to eq(older_entry)
    end

    it 'with the last entry inside the search window it returns the last entry' do
      entry = FactoryGirl.create(:entry, started_at: 1.second.ago, finished_at: Time.now)
      last_entry = FactoryGirl.create(:entry, started_at: Time.now - Entry::SEARCH_WINDOW - 2, finished_at: Time.now - Entry::SEARCH_WINDOW - 1)
      expect(entry.previous).to eq(last_entry)
    end

    it 'with the last entry outside the search window it returns nothing' do
      entry = FactoryGirl.create(:entry, started_at: 1.second.ago, finished_at: Time.now)
      entry_out_of_range = FactoryGirl.create(:entry, started_at: Time.now - Entry::SEARCH_WINDOW - 3, finished_at: Time.now - Entry::SEARCH_WINDOW - 2)
      expect(entry.previous).to be_nil
    end
  end

  it 'a file url results in entry not being non document' do
    expect(new_entry(url: 'file:///Users')          ).to_not be_non_document
    expect(new_entry(url: 'http://www.google.co.uk')).to     be_non_document
    expect(new_entry(url: '')                       ).to     be_non_document
    expect(new_entry(url: nil)                      ).to     be_non_document
  end

  it 'when newing then saving it sets the default project to none' do
    user = FactoryGirl.create(:user)
    entry = user.new_entry(started_at: Time.now, finished_at: 1.second.ago)
    expect(entry.project).to eq(user.none_project)
    expect(entry).to be_valid
  end

  it 'when creating it sets the default project to none' do
    user = FactoryGirl.create(:user)
    entry = user.create_entry(started_at: Time.now, finished_at: 1.second.ago)
    expect(entry.project).to eq(user.none_project)
    expect(entry).to be_valid
  end

  it 'should not allow absolute urls without a path' do
    expect(new_entry(url: 'file://')).to be_invalid
  end

  it 'allows url to be blank' do
    expect(new_entry(url: '')).to be_valid
  end

  it 'can be untrained' do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project) 
    entry = user.create_entry(started_at: Time.now, finished_at: Time.now, project_id: project.id)

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

  it 'marks overlapping entries as invalid' do
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

  describe 'possible paths' do
    it 'when theres a container and another entry the possible paths exclude subdirectories of the container' do
      FactoryGirl.create(:container, path: '/Users/John')
      entry = FactoryGirl.create(:entry, url: 'file:///Users/Mike/Documents/CourtCase/hearing.doc')
      expect(entry.possible_paths).to eq(['/Users', '/Users/Mike', '/Users/Mike/Documents'])
    end

    it 'when theres a container the possible paths exclude subdirectories of the container' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:container, path: '/Users', user: user)
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/lapsus/main.rb', user: user)
      expect(entry.possible_paths).to eq([])
    end

    it 'returns possible container paths' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/lapsus/main.rb')
      expect(entry.possible_paths).to eq(['/Users', '/Users/John', '/Users/John/Code'])
    end
  end
end

def create_project(attrs={})
  user = FactoryGirl.create(:user)
  defaults = { name: 'John', path: '/Users/John', user_id: user.id }
  Project.create(defaults.merge(attrs))
end

def new_entry(attrs={})
  user = FactoryGirl.create(:user)
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00' }
  user.new_entry(defaults.merge(attrs))
end

def create_entry(attrs={})
  user = FactoryGirl.create(:user)
  defaults = { started_at: '2014-01-01 14:00:00', finished_at: '2014-01-01 15:00:00' }
  user.create_entry(defaults.merge(attrs))
end

def assuming_a_container(path)
  user = FactoryGirl.create(:user)
  FactoryGirl.create(:container, name: 'Code', path: path, user_id: user.id)
end
