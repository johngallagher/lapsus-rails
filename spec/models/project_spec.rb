require 'spec_helper'

describe Project do
  it { should respond_to :name, :url }
  it { should have_many :entries }
end
