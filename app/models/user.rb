# frozen_string_literal: true

class User < ApplicationRecord
  def self.import_users
    importer = ::Importers::Users::Processor.new('db/csvs/users.csv')
    if importer.valid?
      importer.process
    else
      importer.errors.full_messages
    end
  end

  def overlapping_events(from_time, to_time = from_time + 2.hours)
    parsed_from_time = Time.zone.parse(from_time.to_s)
    parsed_end_time = Time.zone.parse(to_time.to_s)
    Event.joins(:attendants)
         .where(attendants: { status: ::Attendant::Statuses::YES, user_id: id })
         .where('events.start_time <= ? and events.end_time >= ?', parsed_end_time, parsed_from_time)
  end
end
