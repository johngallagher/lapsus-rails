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
      paths = Container.possible_paths
      expect(paths).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'with no containers and two entries gives combined possible paths' do
      assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
      assuming_an_entry_with_path('/Users/John/PersonalCode/Home/lapsus/main.rb')
      paths = Container.possible_paths
      expect(paths).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code',
        '/Users/John/PersonalCode',
        '/Users/John/PersonalCode/Home'
      ])
    end

    it 'with a container it excludes all conflicting upper directories' do
      assuming_a_container('/Users/John/Code')
      assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
      assuming_an_entry_with_path('/Users/John/PersonalCode/Home/lapsus/main.rb')

      expect(Container.possible_paths).to eq([
        '/Users/John/PersonalCode',
        '/Users/John/PersonalCode/Home'
      ])
    end
  end
end

def assuming_an_entry_with_path(path)
  FactoryGirl.create(:entry, path: path)
end

def assuming_a_container(path)
  Container.create(name: 'Code', path: path)
end
