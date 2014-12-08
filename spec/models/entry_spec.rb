require 'spec_helper'

describe Entry do
  it { should respond_to :started_at }
  it { should respond_to :finished_at }
  it { should respond_to :url }
  it { should belong_to :project }
  it { should validate_presence_of :started_at}
  it { should validate_presence_of :finished_at }
  it { should validate_presence_of :url }
  it { should allow_value('file://User/John', 'http://www.google.com').for(:url) }
  it { should_not allow_value('User', 'hello').for(:url) }
end
