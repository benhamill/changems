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
    @current_version = @gem.current_version
    @current_major_versions = VersionDecorator.decorate(@gem.versions.where(major: @current_version.major).semantic_order('desc'))
    @versions = @gem.versions.semantic_order
  end
end
