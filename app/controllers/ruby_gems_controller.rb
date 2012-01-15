class RubyGemsController < ApplicationController
  def index
  end

  def show
    @gem = RubyGem.find(params[:id])
    @current_version = VersionDecorator.decorate(@gem.current_version)
  end
end
