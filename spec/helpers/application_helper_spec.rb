require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  it 'adds bootstrap classes to flash classes' do
    expect(alert_class(:alert)).to eq('alert-warning')
    expect(alert_class(:notice)).to eq('alert-info')
    expect(alert_class(:error)).to eq('alert-danger')
    expect(alert_class(:something_else)).to eq('alert-info')
  end

  it 'formats durations' do
    expect(as_hours_and_minutes(60)).to eq('0:01')
    expect(as_hours_and_minutes(61)).to eq('0:01')
    expect(as_hours_and_minutes(119)).to eq('0:01')
    expect(as_hours_and_minutes(120)).to eq('0:02')
    expect(as_hours_and_minutes(3600)).to eq('1:00')
  end
end
