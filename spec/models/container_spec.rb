require 'spec_helper'

describe Container do
  it 'when file is deeply nested within a project directory in the container it assigns a project' do
    entry = assuming_an_entry_with_url('/Users/John/Code/rails/Gemfile')
    create_a_container_with_url('/Users/John/Code')
    entry.reload
    expect(entry.project).to be_present
    expect(entry.project.url).to eq('/Users/John/Code/rails')
    expect(entry.project.name).to eq('rails')
  end
end

def assuming_an_entry_with_url(url)
  FactoryGirl.create(:entry, url: url)
end

def create_a_container_with_url(url)
  Container.create_with_projects(name: 'Code', url: url)
end
