require 'spec_helper'
require 'pry'

describe 'lapsus api', type: :request do
  describe 'POST /api/v1/entries' do
    it 'with no containers it creates an entry with no project' do
      post '/api/v1/entries', { entries: [rails_gemfile_from_client]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile.started_at)
      expect(Entry.first.finished_at).to eq(rails_gemfile.finished_at)
      expect(Entry.first.url).to eq('/Users/John/Code/rails/Gemfile')

      expect(Entry.first.project).to be_nil
    end

    it 'with a project that matches the document creates an entry with project' do
      FactoryGirl.create(:container, url: '/Users/John/Code')

      post '/api/v1/entries', { entries: [rails_gemfile_from_client]}, format: :json

      expect(Entry.count).to eq(1)
      expect(Entry.first.started_at).to eq(rails_gemfile.started_at)
      expect(Entry.first.finished_at).to eq(rails_gemfile.finished_at)
      expect(Entry.first.url).to eq('/Users/John/Code/rails/Gemfile')

      expect(Entry.first.project).to be_present
      expect(Entry.first.project.name).to eq('rails')
      expect(Entry.first.project.url).to eq('/Users/John/Code/rails')
    end
  end
end

def rails_gemfile
  FactoryGirl.build(:entry, :rails_gemfile)
end

def rails_gemfile_from_client
  rails_gemfile.attributes.symbolize_keys.slice(:started_at, :finished_at, :url)
end

def document_url
  '/Users/John/Documents/hello.txt'
end

def start_time
  DateTime.parse('2014-01-01 9:11:22')
end

def end_time
  DateTime.parse('2014-01-01 10:22:22')
end
