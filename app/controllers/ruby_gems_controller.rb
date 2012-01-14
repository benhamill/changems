class RubyGemsController < ApplicationController
  def index
  end

  def show
    @gem = RubyGem.find(params[:id])
  end
end
