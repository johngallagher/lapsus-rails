require 'spec_helper'

class DummyClass < Struct.new(:path)
  include Pathable
end

describe Pathable do
  it 'returns path components' do
    mixed_in = DummyClass.new('/Users/John/Code')
    expect(mixed_in.path_components).to eq(['Users', 'John', 'Code'])
  end

  it 'gets directory heirarchy' do
    mixed_in = DummyClass.new('/Users/John/Code')
    expect(mixed_in.path_heirarchy).to eq(['/Users', '/Users/John', '/Users/John/Code'])
  end

  it 'when no path it gets an empty directory heirarchy' do
    mixed_in = DummyClass.new('')
    expect(mixed_in.path_heirarchy).to eq([])
  end
end
