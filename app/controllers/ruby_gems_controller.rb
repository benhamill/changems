class RubyGemsController < ApplicationController
  def index
    if params[:search]
      @gems = RubyGem.search(params[:search]) if params[:search]
      render :search_results and return
    end
  end

  def show
    @gem = RubyGem.find(params[:id])
    @current_version = VersionDecorator.decorate(@gem.current_version)
  end
end
