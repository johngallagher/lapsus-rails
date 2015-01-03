require 'spec_helper'

class DummyClass < Struct.new(:path)
  include Pathable
end

describe Pathable do
  it 'returns path components' do
    pathable = DummyClass.new('/Users/John/Code')
    expect(pathable.path_components).to eq(['Users', 'John', 'Code'])
  end

  it 'gets a path component for the folder if it ends in a slash' do
    pathable = DummyClass.new('/Users/John/Code/')
    expect(pathable.path_components).to eq(['Users', 'John', 'Code', ''])
  end

  it 'gets directory heirarchy' do
    pathable = DummyClass.new('/Users/John/Code')
    expect(pathable.path_heirarchy).to eq(['/Users', '/Users/John', '/Users/John/Code'])
  end

  it 'when no path it gets an empty directory heirarchy' do
    pathable = DummyClass.new('')
    expect(pathable.path_heirarchy).to eq([])
  end
end
