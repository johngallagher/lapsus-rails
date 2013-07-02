require 'spec_helper'

describe Entry do
  it { should respond_to :started_at }
  it { should respond_to :finished_at }
  it { should respond_to :url }
  it { should respond_to :trained }

  it { should belong_to :project }
end
