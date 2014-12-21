require 'spec_helper'

describe User do
  it { should have_many :projects }
  it { should have_many :entries }
  it { should have_many :containers }

  let!(:user) { User.create(email: 'john@jg.com', password: 'password', password_confirmation: 'password') }

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
