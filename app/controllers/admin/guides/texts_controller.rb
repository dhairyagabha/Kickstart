class Admin::Guides::TextsController < Admin::GuidesController
  before_action :set_guides_text, only: [:show, :edit, :update, :destroy]

  # GET /guides/texts
  # GET /guides/texts.json
  def index
    @guides_texts = Guides::Text.all
  end

  # GET /guides/texts/1
  # GET /guides/texts/1.json
  def show
  end

  # GET /guides/texts/new
  def new
    @guides_text = Guides::Text.new
  end

  # GET /guides/texts/1/edit
  def edit
  end

  # POST /guides/texts
  # POST /guides/texts.json
  def create
    @guides_text = Guides::Text.new(guides_text_params)
    @guides_text.user = current_user
    @guides_text.published_at = Time.now
    respond_to do |format|
      if @guides_text.save
        format.html { redirect_to @guides_text, notice: 'Text was successfully created.' }
        format.json { render :show, status: :created, location: @guides_text }
      else
        format.html { render :new }
        format.json { render json: @guides_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guides/texts/1
  # PATCH/PUT /guides/texts/1.json
  def update
    respond_to do |format|
      if @guides_text.update(guides_text_params)
        format.html { redirect_to @guides_text, notice: 'Text was successfully updated.' }
        format.json { render :show, status: :ok, location: @guides_text }
      else
        format.html { render :edit }
        format.json { render json: @guides_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guides/texts/1
  # DELETE /guides/texts/1.json
  def destroy
    @guides_text.destroy
    respond_to do |format|
      format.html { redirect_to guides_texts_url, notice: 'Text was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_guides_text
    @guides_text = Guides::Text.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guides_text_params
    params.require(:guides_text).permit(:title, :content, :user_id, :published_at)
  end
end
