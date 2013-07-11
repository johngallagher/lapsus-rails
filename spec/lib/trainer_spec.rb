require 'spec_helper'

describe Trainer do
  Given(:video)     { FactoryGirl.create(:project, :video) }
  Given(:newsroom)  { FactoryGirl.create(:project, :newsroom) }

  When { Trainer.new(entry, video).train }

  context "training a document" do
    Given(:entry)     { FactoryGirl.create(:entry, :document) }
    Then { entry.should be_trained_for_project(video) }

    context "no rules" do
      Given {}
      Then { Rule.should have(1).items }
    end

    context "a conflicting rule at this level" do
      Given { FactoryGirl.create(:rule, :document) }
      Then { Rule.should have(1).items }
    end

    context "a conflicting rule one level up" do
      Given { FactoryGirl.create(:rule, :parent) }
      Then { Rule.should have(1).items }
    end

    context "a conflicting rule two levels up" do
      Given { FactoryGirl.create(:rule, :grandparent) }
      Then { Rule.should have(1).items }
    end
  end

  context "training a folder" do
    Given(:entry)     { FactoryGirl.create(:entry, :folder) }
    Then { entry.should be_trained_for_project(video) }

    context "no rules" do
      Given {}
      Then { Rule.should have(1).items }
    end

    context "a conflicting rule at this level" do
      Given { FactoryGirl.create(:rule, :folder) }
      Then { Rule.should have(1).items }
    end

    context "a conflicting rule one level down" do
      Given { FactoryGirl.create(:rule, :child) }
      Then { Rule.should have(1).items }
    end

    context "a conflicting rule two levels down" do
      Given { FactoryGirl.create(:rule, :grandchild) }
      Then { Rule.should have(1).items }
    end
  end
end