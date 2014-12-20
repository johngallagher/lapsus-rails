require 'spec_helper'

describe Project do
  it { should respond_to :name, :path }
  it { should respond_to :preset }
  it { should have_many :entries }
  it { should belong_to :user }
end
