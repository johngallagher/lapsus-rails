require 'spec_helper'

describe Container do
  let(:user) { FactoryGirl.create(:user) }

  it { should validate_presence_of :path }
  it { should belong_to :user }

  it 'with an entry two levels below the container it creates the project path' do
    entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile')
    container = FactoryGirl.create(:container, path: '/Users/John/Code')
    expect(container.project_path_from_entry(entry)).to eq('/Users/John/Code/rails')
  end

  describe 'contains project for entry' do
    it 'a document two levels within a container contains a project' do
      container = FactoryGirl.create(:container, path: '/Users/John/Code')
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/app/notes.md', user_id: user.id)
      expect(container.contains_project_for_entry?(entry)).to eq(true)
    end

    it 'a document one level within a container contains a project' do
      container = FactoryGirl.create(:container, path: '/Users/John/Code')
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      expect(container.contains_project_for_entry?(entry)).to eq(true)
    end

    it 'a document at the same level as a container is non project' do
      container = FactoryGirl.create(:container, path: '/Users/John/Code')
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/notes.md', user_id: user.id)
      expect(container.contains_project_for_entry?(entry)).to eq(false)
    end

    it 'a non document is non project' do
      container = FactoryGirl.create(:container, path: '/Users/John/Code')
      entry = FactoryGirl.create(:entry, url: '', user_id: user.id)
      expect(container.contains_project_for_entry?(entry)).to eq(false)
    end

    it 'a web page is never a project' do
      container = FactoryGirl.create(:container, path: '/Users/John/Code')
      entry = FactoryGirl.create(:entry, url: 'http:///Users/John/Code/rails/Gemfile', user_id: user.id)
      expect(container.contains_project_for_entry?(entry)).to eq(false)
    end
  end

  describe 'possible paths' do
    it 'with no containers and one entry gives all possible container paths' do
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      expect(Container.possible_paths(user)).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'excludes web pages' do
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:entry, url: 'http://www.google.co.uk/path/to/a/page', user_id: user.id)
      expect(Container.possible_paths(user)).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'with no containers and two entries gives combined possible paths' do
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
      FactoryGirl.create(:container, path: '/Users/John', user_id: user.id)
      FactoryGirl.create(:entry, url: 'file:///Users/John/Work/Programming/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:entry, url: 'file:///Users/Mike/Personal/gems/lapsus/main.rb', user_id: user.id)

      expect(Container.possible_paths(user)).to eq([
        '/Users/Mike',
        '/Users/Mike/Personal',
        '/Users/Mike/Personal/gems'
      ])
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
