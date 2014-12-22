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

      expect(trained_entry.project.path).to eq('/Users/John/Code/rails')
      expect(trained_entry.project.name).to eq('rails')
      expect(trained_entry).to_not be_changed
    end

    it 'when file is within a project directory in the container it assigns a project' do
      entry = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id)
      FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

      trained_entry = Trainer.train_entry(entry, :normal)

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

    context 'when entry 1 is a project document and entry 2 is application' do
      it 'trains entry 2 to be for no project' do
        rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
        entry_1 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
        entry_2 = FactoryGirl.create(:entry, url: '', user_id: user.id)
        FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

        trained_entry = Trainer.train_entry(entry_2, :normal)

        expect(trained_entry.project).to eq(user.none_project)
        expect(trained_entry).to_not be_changed
      end
    end

    describe 'last active mode' do
      context 'when entry 1 and 2 are both documents' do
        it 'sets non project documents to None' do
          rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
          entry_1 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
          entry_2 = FactoryGirl.create(:entry, url: 'file:///Users/John/.vimrc', user_id: user.id)
          FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

          trained_entry = Trainer.train_entry(entry_2, :last_active)

          expect(trained_entry.project).to eq(user.none_project)
          expect(trained_entry).to_not be_changed
        end

        it 'leaves untouched non project entries before active project entries' do
          rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
          entry_1 = FactoryGirl.create(:entry, url: 'file:///Users/John/.vimrc', user_id: user.id)
          entry_2 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
          FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

          trained_entry = Trainer.train_entry(entry_1, :last_active)

          expect(trained_entry.project).to eq(user.none_project)
          expect(trained_entry).to_not be_changed
        end
      end

      context 'when entry 1 is a project document and entry 2 is application' do
        it 'trains entry 2 for the last active project' do
          rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
          entry_1 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
          entry_2 = FactoryGirl.create(:entry, url: '', user_id: user.id)
          FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

          trained_entry_1 = Trainer.train_entry(entry_1, :last_active)
          trained_entry_2 = Trainer.train_entry(entry_2, :last_active)

          expect(trained_entry_1.project).to eq(rails)
          expect(trained_entry_2.project).to eq(rails)
        end

        xit 'with a time gap of 10 seconds between entries it sets last active project' do
          rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
          entry_1 = FactoryGirl.create(:entry, started_at: 13.seconds.ago, finished_at: 12.seconds.ago, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
          entry_2 = FactoryGirl.create(:entry, started_at: 2.seconds.ago, finished_at: 1.second.ago, url: '', user_id: user.id, project_id: user.none_project.id)
          FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

          trained_entry_1 = Trainer.train_entry(entry_1, :last_active)
          trained_entry_2 = Trainer.train_entry(entry_2, :last_active)

          expect(trained_entry_1.project).to eq(rails)
          expect(trained_entry_2.project).to eq(rails)
        end

        it 'with a time gap of 11 seconds between entries it doesnt look at the last active project' do
          rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
          entry_1 = FactoryGirl.create(:entry, started_at: 14.seconds.ago, finished_at: 13.seconds.ago, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
          entry_2 = FactoryGirl.create(:entry, started_at: 2.seconds.ago, finished_at: 1.second.ago, url: '', user_id: user.id, project_id: user.none_project.id)
          FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

          trained_entry_1 = Trainer.train_entry(entry_1, :last_active)
          trained_entry_2 = Trainer.train_entry(entry_2, :last_active)

          expect(trained_entry_1.project).to eq(rails)
          expect(trained_entry_2.project).to eq(user.none_project)
        end
      end

      context 'when entry 1 is application and entry 2 is document' do
        it 'trains entry 1 for no project and 2 for project' do
          rails = FactoryGirl.create(:project, path: '/Users/John/Code/rails')
          entry_1 = FactoryGirl.create(:entry, url: '', user_id: user.id)
          entry_2 = FactoryGirl.create(:entry, url: 'file:///Users/John/Code/rails/Gemfile', user_id: user.id, project_id: rails.id)
          FactoryGirl.create(:container, path: '/Users/John/Code', user_id: user.id)

          trained_entry_1 = Trainer.train_entry(entry_1, :last_active)
          trained_entry_2 = Trainer.train_entry(entry_2, :last_active)

          expect(trained_entry_1.project).to eq(user.none_project)
          expect(trained_entry_2.project).to eq(rails)
        end
      end
    end
  end
end

