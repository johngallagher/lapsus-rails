require 'spec_helper'

describe Trainer do
  let!(:user) { FactoryGirl.create(:user) }

  context 'when no containers' do
    it 'assigns no project' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/lib/rails/main.rb', user_id: user.id)

      trained_entry = Trainer.train_entry(entry, :normal)

      expect(trained_entry.project).to eq(user.none_project)
      expect(trained_entry).to_not be_changed
    end
  end

  context 'with one container' do
    it 'when file is deeply nested within a project directory in the container it assigns a project' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/lib/rails/main.rb', user_id: user.id)
      FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

      trained_entry = Trainer.train_entry(entry, :normal)

      expect(trained_entry.project).to be_present
      expect(trained_entry.project.path).to eq('/Users/John/Code/rails')
      expect(trained_entry.project.name).to eq('rails')
      expect(trained_entry).to_not be_changed
    end

    it 'when file is within a project directory in the container it assigns a project' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

      trained_entry = Trainer.train_entry(entry, :normal)

      expect(trained_entry.project).to be_present
      expect(trained_entry.project.path).to eq('/Users/John/Code/rails')
      expect(trained_entry.project.name).to eq('rails')
      expect(trained_entry).to_not be_changed
    end

    it 'when file is in the container it doesnt assign any project' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/README.md', user_id: user.id)
      FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

      trained_entry = Trainer.train_entry(entry, :normal)

      expect(trained_entry.project).to eq(user.none_project)
      expect(trained_entry).to_not be_changed
    end

    it 'when entry is outside a container it doesnt assign it to a project' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/.vimrc', user_id: user.id)
      FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

      trained_entry = Trainer.train_entry(entry, :normal)

      expect(trained_entry.project).to eq(user.none_project)
      expect(trained_entry).to_not be_changed
    end

    describe 'last active mode' do
      it 'assigns non project entries to last active project' do
        rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
        entry_1 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
        entry_2 = FactoryGirl.create(:entry, url: 'file:///Users/John/.vimrc', user_id: user.id, project_id: Project.none_for_user(user).id)
        FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

        trained_entry = Trainer.train_entry(entry_2, :last_active)

        expect(trained_entry.project).to eq(rails)
      end

      it 'leaves untouched non project entries before active project entries' do
        rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
        entry_1 = FactoryGirl.create(:entry, url: 'file:///Users/John/.vimrc', user_id: user.id, project_id: Project.none_for_user(user).id)
        entry_2 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
        FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

        trained_entry = Trainer.train_entry(entry_1, :last_active)

        expect(trained_entry.project).to eq(user.none_project)
        expect(trained_entry).to_not be_changed
      end
    end
  end
end

