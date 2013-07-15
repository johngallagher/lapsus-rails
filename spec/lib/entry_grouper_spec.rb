require 'spec_helper'

describe EntryGrouper do

  describe ".group" do
    context "one entry" do
      Given!(:entry) { FactoryGirl.create(:entry, :document, :untrained) }
      
      When { EntryGrouper.new.group }    

      context "no rules" do
        Then { Group.first.url.should == entry.url }
        Then { Group.first.entries.should == [entry] }
        Then { Group.should have(1).group }
      end

      context "one rule for the parents sibling" do
        Given!(:rule) { FactoryGirl.create(:rule, :document_aunt)}

        Then { Group.first.url.should == document_parent_url } # Define parent url
        Then { Group.first.entries.should == [entry] }
        Then { Group.should have(1).group }
      end

      context "context" do

      end
    end
  end  
end