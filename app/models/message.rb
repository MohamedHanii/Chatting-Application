class Message < ActiveRecord::Base
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    belongs_to :chat

    settings do
        mappings dynamic: false do
          indexes :messageContent, type: :text, analyzer: :english
        end
      end

      def self.search(query)
        __elasticsearch__.search(
          query: {
            query_string: {
              query:'*' + query + '*',
              fields: ['messageContent', ]
            }
          }
        )
      end

      def as_indexed_json(_options = nil)
        as_json(only: [:messageContent, :messageNumber])
      end
    
end

