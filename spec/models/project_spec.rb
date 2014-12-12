require 'spec_helper'

describe Project do
  it { should respond_to :name, :path }
  it { should have_many :entries }
end
