# frozen_string_literal: true

# LineItem Model
class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
end
