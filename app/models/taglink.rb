class Taglink < ActiveRecord::Base
    belongs_to :tag
    belongs_to :link
end
