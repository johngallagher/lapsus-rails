require 'spec_helper'

describe User do
  it { should have_many :projects }
  it { should have_many :entries }
  it { should have_many :containers }

  let!(:user) { User.create(email: 'john@jg.com', password: 'password', password_confirmation: 'password') }

  describe 'possible container paths' do
    it 'with no containers and one entry gives all possible container paths' do
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      expect(user.possible_container_paths).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'excludes web pages' do
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:entry, url: 'http://www.google.co.uk/path/to/a/page', user_id: user.id)
      expect(user.possible_container_paths).to eq([
        '/Users',
        '/Users/John',
        '/Users/John/Code'
      ])
    end

    it 'with no containers and two entries gives combined possible paths' do
      FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:entry, url: 'file:///Users/John/PersonalCode/Home/lapsus/main.rb', user_id: user.id)
      expect(user.possible_container_paths).to eq([
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

      expect(user.possible_container_paths).to eq([
        '/Users/Mike',
        '/Users/Mike/Personal',
        '/Users/Mike/Personal/gems'
      ])
    end
  end
  it 'creates a default none project' do
    expect(Project.first).to be_present
    expect(Project.first.preset).to eq(true)
    expect(Project.first.name).to eq('None')
  end

  describe 'building new entries' do
    it 'creates a new entry with a default none project' do
      new_entry = user.new_entry({ 
        started_at: 2.seconds.ago, 
        finished_at: 1.seconds.ago, 
        url: 'file:///Users'
      })

      expect(new_entry.user).to eq(user)
      expect(new_entry.project).to be_present
      expect(new_entry.project.preset).to eq(true)
      expect(new_entry.project.name).to eq('None')
      expect(new_entry.project).to eq(Project.none_for_user(user))
      expect(new_entry).to be_changed
      expect(new_entry).to be_new_record
    end

    it 'with a project supplied it creates the entry with that project' do
      project = FactoryGirl.create(:project)
      new_entry = user.new_entry({ 
        started_at: 2.seconds.ago, 
        finished_at: 1.seconds.ago, 
        url: 'file:///Users',
        project_id: project.id
      })

      expect(new_entry.user).to eq(user)
      expect(new_entry.project).to be_present
      expect(new_entry.project).to eq(project)
      expect(new_entry).to be_changed
      expect(new_entry).to be_new_record
    end
  end

  describe 'creating entries' do
    it 'creates a new entry with a default none project' do
      created_entry = user.create_entry({ 
        started_at: 2.seconds.ago, 
        finished_at: 1.seconds.ago, 
        url: 'file:///Users'
      })

      expect(created_entry.user).to eq(user)
      expect(created_entry.project).to be_present
      expect(created_entry.project.preset).to eq(true)
      expect(created_entry.project.name).to eq('None')
      expect(created_entry.project).to eq(Project.none_for_user(user))
      expect(created_entry).to_not be_changed
      expect(created_entry).to_not be_new_record
      expect(created_entry).to be_valid
    end

    it 'with a project supplied it creates the entry with that project' do
      project = FactoryGirl.create(:project)
      created_entry = user.create_entry({ 
        started_at: 2.seconds.ago, 
        finished_at: 1.seconds.ago, 
        url: 'file:///Users',
        project_id: project.id
      })

      expect(created_entry.user).to eq(user)
      expect(created_entry.project).to be_present
      expect(created_entry.project).to eq(project)
      expect(created_entry).to_not be_changed
      expect(created_entry).to_not be_new_record
      expect(created_entry).to be_valid
    end
  end
end
