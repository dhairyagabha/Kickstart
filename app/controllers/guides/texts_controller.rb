class Guides::TextsController < ApplicationController
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guides_text
      @guides_text = Guides::Text.find(params[:id])
    end

end
