class SearchController < ApplicationController
  skip_authorization_check
  
  def index
    @search = SearchQuery.new(search_params)
    @results = @search.results
  end

  private

  def search_params
    params.require(:search_query).permit(:query_body, :query_object)
  end
end