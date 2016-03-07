class User < ActiveRecord::Base
    has_many :links
    has_many :tags
    has_secure_password
end
