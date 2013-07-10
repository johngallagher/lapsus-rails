require 'spec_helper'

describe Trainer do
  Given(:video)     { FactoryGirl.create(:project, name: "Video") }
  Given(:newsroom)  { FactoryGirl.create(:project, name: "Newsroom") }

  describe ".train" do
    When { Trainer.new(entry, video).train }

    context "entry is a document" do
      Given(:entry)     { FactoryGirl.create(:entry, :document) }    

      context "blank slate" do
        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
      end

      context "trained for newsroom" do
        Given { FactoryGirl.create(:rule, :document, project: newsroom) }

        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
      end

      context "with a conflicting rule at a higher level" do
        Given!(:newsroom_rule) { FactoryGirl.create(:rule, :folder, project: newsroom) }

        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
        Then { newsroom_rule.should be_destroyed }
      end
    end
  end
end