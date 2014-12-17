require 'spec_helper'

describe 'lapsus api', type: :request do
  before(:each) do
    @user = FactoryGirl.create(:user)
    allow_any_instance_of(ApplicationController).to receive(:doorkeeper_token) { double(resource_owner_id: @user.id, acceptable?: true) }
  end

  describe 'POST /api/v1/entries' do
    it 'with no containers it creates an entry with no project' do
      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(response).to have_http_status(:created)
      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.url).to eq(rails_gemfile_document[:url])
      expect(Entry.first.path).to eq('/Users/John/Code/rails/Gemfile')
      expect(Entry.first.user_id).to eq(@user.id)

      expect(Entry.first.project).to be_nil
    end

    it 'with a project that matches the document creates an entry with project' do
      FactoryGirl.create(:container, path: '/Users/John/Code', user_id: @user.id)

      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.url).to eq(rails_gemfile_document[:url])
      expect(Entry.first.path).to eq('/Users/John/Code/rails/Gemfile')
      expect(Entry.first.user_id).to eq(@user.id)

      expect(Entry.first.project).to be_present
      expect(Entry.first.project.name).to eq('rails')
      expect(Entry.first.project.path).to eq('/Users/John/Code/rails')
    end

    it 'with a missing started at it returns errors' do
      post '/api/v1/entries', { entries: [{ finished_at: "2013-01-01 19:00:00" }]}, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON(response.body).first['errors']).to eq(["Started at can't be blank"])
    end
  end
end

def rails_gemfile_document
  {     
    started_at: "2013-07-01 18:23:47",
    finished_at: "2013-07-01 18:23:47",
    url: "file:///Users/John/Code/rails/Gemfile"
  }
end
