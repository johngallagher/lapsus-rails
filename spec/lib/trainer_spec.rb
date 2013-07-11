require 'spec_helper'

describe Trainer do
  Given(:video)     { FactoryGirl.create(:project, :video) }
  Given(:newsroom)  { FactoryGirl.create(:project, :newsroom) }

  describe ".train" do
    When { Trainer.new(entry, video).train }

    context "entry is a document" do
      Given(:entry)     { FactoryGirl.create(:entry, :document) }    

      context "blank slate" do
        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
      end

      context "a conflicting rule at this level" do
        Given { FactoryGirl.create(:rule, :document) }

        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
      end

      context "a conflicting rule one level up" do
        Given { FactoryGirl.create(:rule, :parent) }

        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
      end

      context "a conflicting rule two levels up" do
        Given { FactoryGirl.create(:rule, :grandparent) }

        Then { entry.should be_trained_for_project(video) }
        Then { Rule.should have(1).items }
      end
    end
  end
end