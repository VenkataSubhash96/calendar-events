# frozen_string_literal: true

class Attendant < ApplicationRecord
  module Statuses
    YES = 'yes'
    MAYBE = 'maybe'
    NO = 'no'
  end
end
