require 'rails_helper'

describe 'Specs' do
  it 'should look like this' do
    expect(true).to eq(true)
  end

  it 'can create associations for the initial schema' do
    volunteer1 = log 'vol1', Volunteer.create!(first_name: 'volunteer1')
    volunteer2 = log 'vol2', Volunteer.create!(first_name: 'volunteer2')

    locations  = log 'locations', 2.times.map { |i| Location.create!(name: "Location #{i}") }

    skills     = log 'skills', 3.times.map{ |i| Task::Skill.create!(name: "Skill #{i}")}

    # Volunteer creates a circle
    circle     = log 'circle', Circle.create!(name: 'munich rocks', location: locations[0], admin: volunteer1)
    group      = log 'group',  circle.working_groups.create!(name: 'owners')

    # Volunteer creates a task from a discussion
    task       = log 'task', group.tasks.create!(name: 'foobar')
    task.organizers << volunteer1
    expect(task.organizers).to eq([volunteer1])
    log 'task organizers', task.organizers.map(&:first_name)

    # Task is assigned
    task.volunteers << volunteer2
    expect(task.volunteers).to eq([volunteer2])
    log 'task volunteers', task.volunteers.map(&:first_name)

    # Task skills assigned
    task.skills = skills
    expect(task.skills).to eq(skills)
    expect(task.skill_assignments.count).to eq(3)
    log 'task skills', task.skills.map(&:name)

    # Task location assigned
    task.location_assignments.create location: locations[0], primary: true
    task.location_assignments.create location: locations[1]
    expect(task.locations).to eq(locations)
    log 'task locations', task.locations.map(&:name)

    # System Events
    sys_event     = log 'system event', SystemEvent.create!(volunteer: volunteer1, for: task, action: :removed)
    notification  = log 'notification', sys_event.notifications.create!(volunteer: volunteer2)
    delivery      = log 'email',        notification.deliveries.create!(content: "foobar!", method: :email)

    expect(volunteer2.notifications).to eq([ notification ])
    expect(volunteer2.notifications.first.system_event.volunteer).to eq(volunteer1)
  end

  FMT = "%20s: %s"
  def log tag, obj
    Rails.logger.info FMT % [tag.to_s, obj.inspect]
    obj
  end
end

