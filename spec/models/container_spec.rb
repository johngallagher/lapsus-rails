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

end

def assuming_an_entry_with_url(url)
  FactoryGirl.create(:entry, url: url)
end
