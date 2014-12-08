require 'spec_helper'
require 'pry'

describe 'lapsus api', type: :request do
  describe 'POST /api/v1/entries' do
    it 'with no containers it creates an entry with no project' do
      post '/api/v1/entries', { entries: [rails_gemfile_document]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile_document[:started_at])
      expect(Entry.first.finished_at).to eq(rails_gemfile_document[:finished_at])
      expect(Entry.first.url).to eq(rails_gemfile_document[:url])

      expect(Entry.first.project).to be_nil
    end

    it 'with a project that matches the document creates an entry with project' do
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
  end
end

def rails_gemfile_document
  {     
    started_at: "2013-07-01 18:23:47",
    finished_at: "2013-07-01 18:23:47",
    url: "file:///Users/John/Code/rails/Gemfile"
  }
end
