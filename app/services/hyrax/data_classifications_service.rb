# frozen_string_literal: true

module Hyrax
  class DataClassificationsService < QaSelectService
    def initialize
      super('data_classifications')
    end
  end
end
