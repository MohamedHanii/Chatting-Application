class Application < ActiveRecord::Base
    has_many :chats, dependent: :destroy
end
