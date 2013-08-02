class RubyGemsController < ApplicationController
  def index
    if params[:search]
      @gems = RubyGem.search(params[:search]) if params[:search]
      render :search_results and return
    end

    @featured_gems = RubyGem.featured
  end

  def show
    @gem = RubyGem.friendly.find(params[:id])
    @versions = VersionDecorator.decorate(@gem.versions.semantic_order('desc'))

    respond_to do |format|
      format.html
      format.json { render json: @versions, each_serializer: VersionSerializer }
    end
  end
end
