# frozen_string_literal: true

# Customer Model
class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
end
