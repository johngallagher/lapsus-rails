require 'spec_helper'

describe Report do
  describe 'non time grouped report' do
    it 'defaults to today for the range' do
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      assuming_an_entry_for_project(1.minute.ago, Time.now, lapsus, john)

      report = Report.new(user: john)
      expect(report.run).to eq({ 'lapsus' => 0.02 })
    end

    it 'only gets times for the specified user' do
      mike = assuming_a_user
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      assuming_an_entry_for_project('01-01-2014 00:01:00', '01-01-2014 00:02:00', lapsus, john)

      report = Report.new(range: '01-01-2014 - 01-01-2014', user: mike)

      expect(report.run).to eq({})
    end

    it 'with one project and one entry it shows total time' do
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      assuming_an_entry_for_project('01-01-2014 00:01:00', '01-01-2014 00:02:00', lapsus, john)

      report = Report.new(range: '01-01-2014 - 01-01-2014', user: john)

      expect(report.run).to eq({ 'lapsus' => 0.02 })
    end

    it 'with two entries for the same project it returns sum for projects' do
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      assuming_an_entry_for_project('01-01-2014 00:01:00', '01-01-2014 00:02:00', lapsus, john)
      assuming_an_entry_for_project('01-01-2014 00:02:00', '01-01-2014 00:03:00', lapsus, john)

      report = Report.new(range: '01-01-2014 - 01-01-2014', user: john)

      expect(report.run).to eq({ 'lapsus' => 0.03 })
    end

    it 'with two entries for different projects it returns both projects' do
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      rails = assuming_a_project_for_user('rails', john)
      assuming_an_entry_for_project('01-01-2014 00:01:00', '01-01-2014 00:02:00', lapsus, john)
      assuming_an_entry_for_project('01-01-2014 00:02:00', '01-01-2014 00:03:00', rails, john)

      report = Report.new(range: '01-01-2014 - 01-01-2014', user: john)

      expect(report.run).to eq({ 'lapsus' => 0.02, 'rails' => 0.02 })
    end
  end

  describe 'time grouped report' do
    it 'with a range of one day it groups by hour' do
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      rails = assuming_a_project_for_user('rails', john)
      assuming_an_entry_for_project('01-01-2014 00:01:00', '01-01-2014 00:02:00', lapsus, john)
      assuming_an_entry_for_project('01-01-2014 00:02:00', '01-01-2014 00:03:00', rails, john)

      report = Report.new(range: '01-01-2014 - 01-01-2014', user: john)

      expect(report.run_time_grouped).to eq({
        ['lapsus', '0:00'] => 1.0,
        ['rails', '0:00'] => 1.0 
      })
    end

    it 'with a range of two days it groups by day' do
      john = assuming_a_user
      lapsus = assuming_a_project_for_user('lapsus', john)
      rails = assuming_a_project_for_user('rails', john)
      assuming_an_entry_for_project('01-01-2014 00:01:00', '01-01-2014 00:02:00', lapsus, john)
      assuming_an_entry_for_project('02-01-2014 00:01:00', '02-01-2014 00:02:00', rails, john)

      report = Report.new(range: '01-01-2014 - 02-01-2014', user: john)

      expect(report.run_time_grouped).to eq({
        ['lapsus', '01-01'] => 0.02,
        ['lapsus', '02-01'] => 0.0,
        ['rails', '01-01'] => 0.0,
        ['rails', '02-01'] => 0.02
      })
    end

  end
end

def assuming_a_user
  FactoryGirl.create(:user)
end

def assuming_a_project_for_user(name, user)
  FactoryGirl.create(:project, name: name, user_id: user.id)
end

def assuming_an_entry_for_project(started_at, finished_at, project, user)
  FactoryGirl.create(:entry, started_at: started_at, finished_at: finished_at, project: project, user_id: user.id)
end
