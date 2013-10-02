require 'spec_helper'

describe EntryGrouper do

  describe ".group" do
    context "one entry" do
      Given!(:entry) { FactoryGirl.create(:entry, :cheese_document, :untrained) }

      When { EntryGrouper.new.group }    

      Then { Group.first.entries.should == [entry] }
      Then { Group.should have(1).group }

      context "no rules" do
        Then { Group.first.url.should == entry.url }
      end

      context "one rule for documents" do
        Given!(:rule) { FactoryGirl.create(:rule, :documents_folder)}

        Then { Group.first.url.should == rule.url }
      end
    end
  end  
end