require 'spec_helper'

describe Trainer do
  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
    assuming_a_container('/Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.path).to eq('/Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end

  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    assuming_an_entry_with_path('/Users/John/Code/rails/lib/rails/main.rb')
    assuming_a_container('/Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.path).to eq('/Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end

  it 'when file is within a project directory in the container it assigns a project' do
    assuming_an_entry_with_path('/Users/John/Code/rails/Gemfile')
    assuming_a_container('/Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_present
    expect(Entry.first.project.path).to eq('/Users/John/Code/rails')
    expect(Entry.first.project.name).to eq('rails')
  end

  it 'when file is in the container it doesnt assign any project' do
    assuming_an_entry_with_path('/Users/John/Code/README.md')
    assuming_a_container('/Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_nil
  end

  it 'when entry is outside a container it doesnt assign it to a project' do
    assuming_an_entry_with_path('/Users/John/.vimrc')
    assuming_a_container('/Users/John/Code')
    Trainer.train
    expect(Entry.first.project).to be_nil
  end
end

def assuming_an_entry_with_path(path)
  FactoryGirl.create(:entry, path: path)
end

def assuming_a_container(path)
  Container.create(name: 'Code', path: path)
end
