module Stafftools
  class ResourcesController < StafftoolsController
    before_action :set_resources

    def index
    end

    def search
      respond_to do |format|
        format.html { render partial: 'stafftools/resources/search_results', locals: { resources: @resources } }
      end
    end

    private

    def set_resources
      resource_query = params[:query].present? ? match_phrase_prefix(params[:query]) : {}
      @resources     = StafftoolsIndex::User.query(resource_query).order(updated_at: :desc).page(params[:page]).per(20)
    end

    def match_phrase_prefix(query)
      { bool: { should: %w(id uid name login).map { |field| { 'match_phrase_prefix' => { field => query } } } } }
    end
  end
end
