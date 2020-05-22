class Score < ApplicationRecord
  belongs_to :result
  belongs_to :student
end
