class VersionsController < ApplicationController
  def show
    @version = VersionDecorator.find(params[:id])
    @gem = @version.ruby_gem
  end

  def range
    @start_version = Version.find(params[:start_id])
    @end_version = Version.find(params[:end_id])
    @gem = @start_version.ruby_gem

    @versions = VersionDecorator.decorate(@gem.versions.between(@start_version, @end_version).semantic_order)
  end
end
