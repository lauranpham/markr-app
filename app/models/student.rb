class Student < ApplicationRecord
    has_many :scores
    validates_presence_of :id
end
