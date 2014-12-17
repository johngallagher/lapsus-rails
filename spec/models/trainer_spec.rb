require 'spec_helper'

describe Trainer do
  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/lib/rails/main.rb', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    trained_entry = Trainer.train_entry(entry)

    expect(trained_entry.project).to be_present
    expect(trained_entry.project.path).to eq('/Users/John/Code/rails')
    expect(trained_entry.project.name).to eq('rails')
    expect(trained_entry).to_not be_changed
  end

  it 'when file is within a project directory in the container it assigns a project' do
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    trained_entry = Trainer.train_entry(entry)

    expect(trained_entry.project).to be_present
    expect(trained_entry.project.path).to eq('/Users/John/Code/rails')
    expect(trained_entry.project.name).to eq('rails')
    expect(trained_entry).to_not be_changed
  end

  it 'when file is in the container it doesnt assign any project' do
    none = FactoryGirl.create(:project, preset: true)
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/README.md', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    trained_entry = Trainer.train_entry(entry)

    expect(trained_entry.project).to eq(none)
    expect(trained_entry).to_not be_changed
  end

  it 'when entry is outside a container it doesnt assign it to a project' do
    none = FactoryGirl.create(:project, preset: true)
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, url: 'file:///Users/John/.vimrc', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    trained_entry = Trainer.train_entry(entry)

    expect(trained_entry.project).to eq(none)
    expect(trained_entry).to_not be_changed
  end
end

