require 'spec_helper'

describe Trainer do
  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    assuming_an_entry_with_url('file:///Users/John/Code/rails/Gemfile')
    assuming_a_container('file:///Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.url).to eq('file:///Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end

  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    assuming_an_entry_with_url('file:///Users/John/Code/rails/lib/rails/main.rb')
    assuming_a_container('file:///Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.url).to eq('file:///Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end

  it 'when file is within a project directory in the container it assigns a project' do
    assuming_an_entry_with_url('file:///Users/John/Code/rails/Gemfile')
    assuming_a_container('file:///Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.url).to eq('file:///Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end

  it 'when file is in the container it doesnt assign any project' do
    assuming_an_entry_with_url('file:///Users/John/Code/README.md')
    assuming_a_container('file:///Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_nil
  end

  it 'when entry is outside a container it doesnt assign it to a project' do
    assuming_an_entry_with_url('file:///Users/John/.vimrc')
    assuming_a_container('file:///Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_nil
  end
end

def assuming_an_entry_with_url(url)
  FactoryGirl.create(:entry, url: url)
end

def assuming_a_container(url)
  Container.create(name: 'Code', url: url)
end
