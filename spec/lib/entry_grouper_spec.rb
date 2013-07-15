require 'spec_helper'

describe EntryGrouper do

  describe ".group" do
    context "no rules one untrained entry" do
      Given!(:entry) { FactoryGirl.create(:entry, :document, :untrained) }

      When { EntryGrouper.new.group }

      Then { Group.should have(1).group }
      Then { Group.first.url.should == entry.url }
      Then { Group.first.entries.should == [entry] }
    end
  end  
end