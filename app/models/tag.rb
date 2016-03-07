class Tag < ActiveRecord::Base
    has_many :taglinks
    has_many :links, through: :taglinks
    belongs_to :user
end
