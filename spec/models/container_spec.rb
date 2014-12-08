require 'spec_helper'

describe Container do
  it 'with no containers and one entry gives all possible container urls' do
    assuming_an_entry_with_url('/Users/John/Code/rails/Gemfile')
    urls = Container.possible_urls
    expect(urls).to eq([
      '/',
      '/Users',
      '/Users/John',
      '/Users/John/Code'
    ])
  end

  it 'with no containers and two entries gives combined possible urls' do
    assuming_an_entry_with_url('/Users/John/Code/rails/Gemfile')
    assuming_an_entry_with_url('/Users/John/PersonalCode/Home/lapsus/main.rb')
    urls = Container.possible_urls
    expect(urls).to eq([
      '/',
      '/Users',
      '/Users/John',
      '/Users/John/Code',
      '/Users/John/PersonalCode',
      '/Users/John/PersonalCode/Home'
    ])
  end

  it 'with a container already in place it excludes all possible subdirectories' do
    assuming_a_container('/Users/John/PersonalCode/Main')
    assuming_an_entry_with_url('/Users/John/Code/rails/Gemfile')
    assuming_an_entry_with_url('/Users/John/PersonalCode/Home/lapsus/main.rb')
    assuming_an_entry_with_url('/Users/John/PersonalCode/Main/generator/package.json')
    Trainer.train
    urls = Container.possible_urls
    expect(urls).to eq([
      '/',
      '/Users',
      '/Users/John',
      '/Users/John/Code',
      '/Users/John/PersonalCode',
      '/Users/John/PersonalCode/Home'
    ])
  end
end

def assuming_an_entry_with_url(url)
  FactoryGirl.create(:entry, url: url)
end

def assuming_a_container(url)
  Container.create(name: 'Code', url: url)
end
