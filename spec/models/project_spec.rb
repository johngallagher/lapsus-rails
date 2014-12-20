require 'spec_helper'

describe Project do
  it { should respond_to :name, :path }
  it { should respond_to :preset }
  it { should have_many :entries }

  it 'creates a default none project for a user' do
    user = FactoryGirl.create(:user)
    no_project = FactoryGirl.create(:project, :none, user_id: user.id)
    found_project = Project.none_for_user(user)
    expect(found_project).to be_present
    expect(found_project).to eq(no_project)
  end
end
