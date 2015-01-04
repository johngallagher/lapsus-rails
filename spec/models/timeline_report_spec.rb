require 'spec_helper'

describe TimelineReport do
  it 'with one entry in one project it returns array of project and start stop times' do
    user = assuming_a_user
    FactoryGirl.create(:entry, started_at: '2014-01-01 00:30:00', finished_at: '2014-01-01 00:40:00', user: user)
    expect(TimelineReport.with(user: user).run).to eq([['None', '2014-01-01 00:30:00', '2014-01-01 00:40:00']])
  end

  it 'with two entries in two projects it returns array of project and start stop times' do
    user = assuming_a_user
    lapsus = FactoryGirl.create(:project, name: 'lapsus-rails')
    FactoryGirl.create(:entry, started_at: '2014-01-01 00:30:00', finished_at: '2014-01-01 00:40:00', project: lapsus, user: user)
    FactoryGirl.create(:entry, started_at: '2014-01-01 00:40:00', finished_at: '2014-01-01 00:50:00', user: user) 

    expect(TimelineReport.with(user: user).run).to eq([
      ['lapsus-rails', '2014-01-01 00:30:00', '2014-01-01 00:40:00'],
      ['None', '2014-01-01 00:40:00', '2014-01-01 00:50:00']
    ])
  end
end

def assuming_a_user
  FactoryGirl.create(:user)
end

