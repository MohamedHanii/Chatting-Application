class Chat < ActiveRecord::Base
    belongs_to :application
    has_many :messages, dependent: :destroy
end
