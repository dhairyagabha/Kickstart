class Admin::AnnouncementsController < Admin::BaseController

  def index
    @announcements = Announcement.order(created_at: :desc)
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    if @announcement.save
      redirect_to admin_announcements_path, notice: 'Announcement broadcasted successfully!'
    else
      render :new
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update!(announcement_params)
      redirect_to admin_announcements_path, notice: 'Announcement broadcasted successfully!'
    else
      render :edit
    end
  end

  private
  def announcement_params
    params.require(:announcement).permit(:announcement_type, :name, :description)
  end

end
