class VersionsController < ApplicationController
  def show
    @version = VersionDecorator.find(params[:id])
    @gem = @version.ruby_gem
  end
end
