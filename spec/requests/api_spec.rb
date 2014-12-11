require 'spec_helper'

describe 'lapsus api', type: :request do
  describe 'POST /api/v1/entries' do
    xit 'with no containers it creates an entry with no project' do
      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.url).to eq(rails_gemfile_document[:url])

      expect(Entry.first.project).to be_nil
    end

    xit 'with a project that matches the document creates an entry with project' do
      FactoryGirl.create(:container, url: 'file:///Users/John/Code')

      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.url).to eq(rails_gemfile_document[:url])

      expect(Entry.first.project).to be_present
      expect(Entry.first.project.name).to eq('rails')
      expect(Entry.first.project.url).to eq('file:///Users/John/Code/rails')
    end

    xit 'with an invalid url it returns errors' do
      post '/api/v1/entries', { entries: [{ started_at: "2013-01-01 18:00:00", finished_at: "2013-01-01 19:00:00", url: 'invalid' }]}, format: :json
      expect(response.status).to eq(500)
      expect(response.body).to eq('{"error":"Validation failed: Url is invalid"}')

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
