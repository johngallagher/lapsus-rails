require 'spec_helper'

describe Container do
  it { should validate_presence_of :url }
  it { should allow_value('file:///User/John', 'http://www.google.com').for(:url) }
  it { should_not allow_value('User', 'hello').for(:url) }

  it 'with an entry two levels below the container it creates the project url' do
    entry = assuming_an_entry_with_url('file:///Users/John/Code/rails/Gemfile')
    container = assuming_a_container('file:///Users/John/Code')
    expect(container.project_url_from_entry(entry)).to eq('file:///Users/John/Code/rails')
  end

  it 'with no containers and one entry gives all possible container urls' do
    assuming_an_entry_with_url('file:///Users/John/Code/rails/Gemfile')
    urls = Container.possible_urls
    expect(urls).to eq([
      'file:',
      'file:///Users',
      'file:///Users/John',
      'file:///Users/John/Code'
    ])
  end

  it 'with no containers and two entries gives combined possible urls' do
    assuming_an_entry_with_url('file:///Users/John/Code/rails/Gemfile')
    assuming_an_entry_with_url('file:///Users/John/PersonalCode/Home/lapsus/main.rb')
    urls = Container.possible_urls
    expect(urls).to eq([
      'file:',
      'file:///Users',
      'file:///Users/John',
      'file:///Users/John/Code',
      'file:///Users/John/PersonalCode',
      'file:///Users/John/PersonalCode/Home'
    ])
  end

  it 'with a container already in place it excludes all possible subdirectories' do
    assuming_an_entry_with_url('file:///Users/John/Code/rails/Gemfile')
    assuming_an_entry_with_url('file:///Users/John/PersonalCode/Home/lapsus/main.rb')
    assuming_an_entry_with_url_and_project('file:///Users/John/PersonalCode/Main/generator/package.json', 'file:///Users/John/PersonalCode/Main')
    urls = Container.possible_urls
    expect(urls).to eq([
      'file:',
      'file:///Users',
      'file:///Users/John',
      'file:///Users/John/Code',
      'file:///Users/John/PersonalCode',
      'file:///Users/John/PersonalCode/Home'
    ])
  end
end

def assuming_an_entry_with_url_and_project(url, project_url)
  project = Project.create(url: project_url)
  FactoryGirl.create(:entry, url: url, project: project)
end

def assuming_an_entry_with_url(url)
  FactoryGirl.create(:entry, url: url)
end

def assuming_a_container(url)
  Container.create(name: 'Code', url: url)
end