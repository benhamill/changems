class RubyGemsController < ApplicationController
  def index
    if params[:search]
      @gems = RubyGem.search(params[:search]) if params[:search]
      render :search_results and return
    end

    @featured_gems = RubyGem.where(name: 'none_such')
  end

  def show
    @gem = RubyGem.find(params[:id])
    @versions = VersionDecorator.decorate(@gem.versions.semantic_order('desc'))
  end
end
