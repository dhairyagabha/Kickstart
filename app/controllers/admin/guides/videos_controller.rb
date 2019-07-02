class Admin::Guides::VideosController < Admin::GuidesController
  before_action :set_guides_text, only: [:show, :edit, :update, :destroy]

  # GET /guides/videos
  # GET /guides/videos.json
  def index
    @guides_videos = Guides::Video.all
  end

  # GET /guides/videos/1
  # GET /guides/videos/1.json
  def show
  end

  # GET /guides/videos/new
  def new
    @guides_video = Guides::Video.new
  end

  # GET /guides/videos/1/edit
  def edit
  end

  # POST /guides/videos
  # POST /guides/videos.json
  def create
    @guides_video = Guides::Video.new(guides_video_params)
    @guides_video.published_at = Time.now
    respond_to do |format|
      if @guides_video.save
        format.html { redirect_to @guides_video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @guides_video }
      else
        format.html { render :new }
        format.json { render json: @guides_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guides/videos/1
  # PATCH/PUT /guides/videos/1.json
  def update
    respond_to do |format|
      if @guides_video.update(guides_video_params)
        format.html { redirect_to @guides_video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @guides_video }
      else
        format.html { render :edit }
        format.json { render json: @guides_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guides/videos/1
  # DELETE /guides/videos/1.json
  def destroy
    @guides_video.destroy
    respond_to do |format|
      format.html { redirect_to guides_videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_guides_text
    @guides_video = Guides::Video.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guides_video_params
    params.require(:guides_video).permit(:title, :content, :video_link)
  end


end
