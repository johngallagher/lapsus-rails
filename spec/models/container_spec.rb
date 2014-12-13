require 'spec_helper'

describe Container do
  it { should validate_presence_of :path }

  it 'with an entry two levels below the container it creates the project path' do
    entry = assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
    container = assuming_a_container('/Users/John/Code')
    expect(container.project_path_from_entry(entry)).to eq('/Users/John/Code/rails')
  end

  describe 'possible paths' do
    it 'with no containers and one entry gives all possible container paths' do
      assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
      expect(Container.possible_paths).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'with no containers and two entries gives combined possible paths' do
      assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
      assuming_an_entry_with_path('/Users/John/PersonalCode/Home/lapsus/main.rb')
      expect(Container.possible_paths).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code',
        '/Users/John/PersonalCode',
        '/Users/John/PersonalCode/Home'
      ])
    end

    it 'with a container it excludes all conflicting upper directories' do
      assuming_a_container('/Users/John')
      assuming_an_entry_with_path('/Users/John/Work/Programming/rails/Gemfile')
      assuming_an_entry_with_path('/Users/Mike/Personal/gems/lapsus/main.rb')

      expect(Container.possible_paths).to eq([
        '/Users/Mike',
        '/Users/Mike/Personal',
        '/Users/Mike/Personal/gems'
      ])
    end

    it 'when theres a container and another entry the possible paths exclude subdirectories of the container' do
      assuming_a_container('/Users/John')
      entry = assuming_an_entry_with_path('/Users/Mike/Documents/CourtCase/hearing.doc')
      expect(Container.possible_paths_for(entry, Container.all)).to eq(['/Users', '/Users/Mike', '/Users/Mike/Documents'])
    end

    it 'when theres a container the possible paths exclude subdirectories of the container' do
      assuming_a_container('/Users')
      entry = assuming_an_entry_with_path('/Users/John/Code/lapsus/main.rb')
      expect(Container.possible_paths_for(entry, Container.all)).to eq([])
    end

    it 'returns possible container paths' do
      entry = assuming_an_entry_with_path('/Users/John/Code/lapsus/main.rb')
      expect(Container.possible_paths_for(entry, Container.all)).to eq(['/Users', '/Users/John', '/Users/John/Code'])
    end
  end
end

def assuming_an_entry_with_path(path)
  FactoryGirl.create(:entry, path: path)
end

def assuming_a_container(path)
  Container.create(name: 'Code', path: path)
end
