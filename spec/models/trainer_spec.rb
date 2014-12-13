require 'spec_helper'

describe Trainer do
  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, path: '/Users/John/Code/rails/lib/rails/main.rb', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    Trainer.train_for(user)

    entry.reload
    expect(entry.project).to be_present
    expect(entry.project.path).to eq('/Users/John/Code/rails')
    expect(entry.project.name).to eq('rails')
  end

  it 'when file is within a project directory in the container it assigns a project' do
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, path: '/Users/John/Code/rails/Gemfile', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    Trainer.train_for(user)

    entry.reload
    expect(entry.project).to be_present
    expect(entry.project.path).to eq('/Users/John/Code/rails')
    expect(entry.project.name).to eq('rails')
  end

  it 'when file is in the container it doesnt assign any project' do
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, path: '/Users/John/Code/README.md', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    Trainer.train_for(user)

    entry.reload
    expect(entry.project).to be_nil
  end

  it 'when entry is outside a container it doesnt assign it to a project' do
    user = FactoryGirl.create(:user)
    entry = FactoryGirl.create(:entry, path: '/Users/John/.vimrc', user_id: user.id)
    FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

    Trainer.train_for(user)

    entry.reload
    expect(entry.project).to be_nil
  end
end

