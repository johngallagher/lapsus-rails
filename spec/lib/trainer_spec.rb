require 'spec_helper'

describe Trainer do
  Given { Rule.destroy_all}
  Given(:entry)   { FactoryGirl.create(:entry) }
  Given(:video_project) { FactoryGirl.create(:project, name: "Video") }
  Given(:newsroom_project) { FactoryGirl.create(:project, name: "Newsroom") }

  context "no previous rules" do
    When { Trainer.new(entry, video_project).train }

    Then { entry.should be_trained }
    Then { entry.project.should == video_project }
    Then { Rule.all.should have(1).items }
    Then { Rule.first.url.should == entry.url }    
  end

  context "entry has already been trained for newsroom" do
    Given!(:newsroom_rule)    { FactoryGirl.create(:rule, url: entry.url, project: newsroom_project) }
    
    When { Trainer.new(entry, video_project).train }

    Then { entry.should be_trained }
    Then { entry.project.should == video_project }
    Then { Rule.all.should have(1).items }
    Then { Rule.first.project.should == video_project }
  end
end