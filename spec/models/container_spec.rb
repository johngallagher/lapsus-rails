require 'spec_helper'

describe Container do
  it { should validate_presence_of :path }

  it 'with an entry two levels below the container it creates the project path' do
    entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile')
    container = FactoryGirl.create(:container, path: '/Users/John/Code')
    expect(container.project_path_from_entry(entry)).to eq('/Users/John/Code/rails')
  end

  describe 'possible paths' do
    let(:user) { FactoryGirl.create(:user) }

    it 'with no containers and one entry gives all possible container paths' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      expect(Container.possible_paths(user)).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'with no containers and two entries gives combined possible paths' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:entry, url: 'file:///Users/John/PersonalCode/Home/lapsus/main.rb', user_id: user.id)
      expect(Container.possible_paths(user)).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code',
        '/Users/John/PersonalCode',
        '/Users/John/PersonalCode/Home'
      ])
    end

    it 'with a container it excludes all conflicting upper directories' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:container, path: '/Users/John', user_id: user.id)
      FactoryGirl.create(:entry, url: 'file:///Users/John/Work/Programming/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:entry, url: 'file:///Users/Mike/Personal/gems/lapsus/main.rb', user_id: user.id)

      expect(Container.possible_paths(user)).to eq([
        '/Users/Mike',
        '/Users/Mike/Personal',
        '/Users/Mike/Personal/gems'
      ])
    end

    it 'when theres a container and another entry the possible paths exclude subdirectories of the container' do
      FactoryGirl.create(:container, path: '/Users/John')
      entry = FactoryGirl.create(:entry, url: 'file:///Users/Mike/Documents/CourtCase/hearing.doc')
      expect(Container.possible_paths_for(entry, Container.all)).to eq(['/Users', '/Users/Mike', '/Users/Mike/Documents'])
    end

    it 'when theres a container the possible paths exclude subdirectories of the container' do
      FactoryGirl.create(:container, path: '/Users')
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/lapsus/main.rb')
      expect(Container.possible_paths_for(entry, Container.all)).to eq([])
    end

    it 'returns possible container paths' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/lapsus/main.rb')
      expect(Container.possible_paths_for(entry, Container.all)).to eq(['/Users', '/Users/John', '/Users/John/Code'])
    end

  end

end

def assuming_a_user
  FactoryGirl.create(:user)
end

def assuming_an_entry_with_path(path)
  FactoryGirl.create(:entry, path: path)
end

def assuming_a_container(path)
  FactoryGirl.create(:container, path: path)
end
