class Admin::GuidesController < Admin::BaseController

  def index
    @text_guides = Guides::Text.order(created_at: :desc)
    @video_guides = Guides::Video.order(created_at: :desc)
  end

end