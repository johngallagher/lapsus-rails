require 'spec_helper'

describe Trainer do
  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    assuming_an_entry_with_url('/Users/John/Code/rails/Gemfile')
    assuming_a_container('/Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.url).to eq('/Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end
end

def assuming_an_entry_with_url(url)
  FactoryGirl.create(:entry, url: url)
end

def assuming_a_container(url)
  Container.create(name: 'Code', url: url)
end
