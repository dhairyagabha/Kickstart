json.extract! guides_text, :id, :title, :user_id, :published_at, :created_at, :updated_at
json.url guides_text_url(guides_text, format: :json)
