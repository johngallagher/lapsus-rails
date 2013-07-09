require 'spec_helper'

describe Trainer do
  Given(:entry)     { FactoryGirl.create(:entry) }
  Given(:video)     { FactoryGirl.create(:project, name: "Video") }
  Given(:newsroom)  { FactoryGirl.create(:project, name: "Newsroom") }
  
  describe ".train" do
    When { Trainer.new(entry, video).train }

    context "blank slate" do
      Then { entry.should be_trained_for_project(video) }
      Then { Rule.should have(1).items }
    end

    context "same url trained for newsroom" do
      Given { FactoryGirl.create(:rule, url: entry.url, project: newsroom) }

      Then { entry.should be_trained_for_project(video) }
      Then { Rule.should have(1).items }
    end

    context "different entry, same url" do
      Given(:entry_2) { FactoryGirl.create(:entry) }

      Then { entry.should be_trained_for_project(video) }
      Then { Rule.should have(1).items }
    end
  end
end