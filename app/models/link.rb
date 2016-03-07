class Link < ActiveRecord::Base
    has_many :taglinks
    has_many :tags, through: :taglinks
    belongs_to :user
end
