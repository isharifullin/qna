class SearchQuery
  include ActiveModel::Model
  
  attr_accessor :query_body, :query_object

  validates :query_body, presence: true
  validates :query_object, inclusion: { in: %w(All Question Answer Comment User) }

  def results
    unless valid?
      return []
    else
      if query_object == 'All'
        ThinkingSphinx.search query_body, order: 'created_at DESC'
      else
        query_object.constantize.search query_body, order: 'created_at DESC'
      end
    end
  end
end