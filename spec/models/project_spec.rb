require 'spec_helper'

describe Project do
  it { should respond_to :name }
  it { should have_many :entries }
  it { should have_many :rules }
end
