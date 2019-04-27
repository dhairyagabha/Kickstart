class Guides::VideosController < ApplicationController

  def index
    @videos = Guides::Video.order(created_at: :desc)
  end

end
