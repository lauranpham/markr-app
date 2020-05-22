class Score < ApplicationRecord
  belongs_to :result
  belongs_to :student
  validates_presence_of :obtained, :available, :result, :student
end
