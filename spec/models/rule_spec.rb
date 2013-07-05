require 'spec_helper'

describe Rule do
  it { should respond_to :url }
  it { should validate_presence_of :url }
end