require 'spec_helper'

describe Trainer do
  Given!(:entry)   { FactoryGirl.create(:entry) }
  Given!(:project) { FactoryGirl.create(:project) }

  When { Trainer.new(entry, project).train }

  Then { entry.should be_trained }
end