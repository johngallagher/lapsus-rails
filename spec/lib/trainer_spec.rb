require 'spec_helper'

describe Trainer do
  Given!(:entry)   { FactoryGirl.create(:entry) }
  Given!(:project) { FactoryGirl.create(:project) }

  When { Trainer.new(entry, project).train }

  Then { entry.should be_trained }
  Then { entry.project.should == project }
  Then { Rule.all.count.should == 1 }
  Then { Rule.first.url.should == entry.url }
end