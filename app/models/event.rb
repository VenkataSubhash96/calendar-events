# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :attendants

  module Statuses
    UPCOMING = 'upcoming'
    IN_PROGRESS = 'in_progress'
    COMPLETED = 'completed'
  end

  def self.import_events
    importer = ::Importers::Events::Processor.new('db/csvs/events.csv')
    if importer.valid?
      importer.process
    else
      importer.errors.full_messages
    end
  end
end
