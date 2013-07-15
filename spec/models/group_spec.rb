require 'spec_helper'

describe Group do
  it { should respond_to :url }
  it { should have_many :entries }
end