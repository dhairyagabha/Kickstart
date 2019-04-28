class Admin::GuidesController < Admin::BaseController

  def index
    # @text_guides = Guides::Text.all
    @video_guides = Guides::Video.order(created_at: :desc)
  end

end