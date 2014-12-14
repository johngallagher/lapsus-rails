require 'spec_helper'

describe 'lapsus api', type: :request, vcr: true do
  describe 'POST /api/v1/entries' do
    it 'with no containers it creates an entry with no project' do
      user = FactoryGirl.create(:user)
      allow_any_instance_of(ApplicationController).to receive(:doorkeeper_token) { double(resource_owner_id: user.id, acceptable?: true) }
      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(response).to have_http_status(:created)
      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.path).to eq(rails_gemfile_document[:path])

      expect(Entry.first.project).to be_nil
    end

    xit 'with a project that matches the document creates an entry with project' do
      FactoryGirl.create(:container, path: '/Users/John/Code')

      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.path).to eq(rails_gemfile_document[:path])

      expect(Entry.first.project).to be_present
      expect(Entry.first.project.name).to eq('rails')
      expect(Entry.first.project.path).to eq('/Users/John/Code/rails')
    end

    xit 'with an invalid path it returns errors' do
      post '/api/v1/entries', { entries: [{ started_at: "2013-01-01 18:00:00", finished_at: "2013-01-01 19:00:00" }]}, format: :json
      expect(response.status).to eq(422)
      expect(JSON(response.body).first['errors']).to eq(["Path can't be blank"])
    end
  end
end

def rails_gemfile_document
  {     
    started_at: "2013-07-01 18:23:47",
    finished_at: "2013-07-01 18:23:47",
    path: "/Users/John/Code/rails/Gemfile"
  }
end
