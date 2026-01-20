json.extract! sermon, :id, :title, :description, :link, :created_at, :updated_at
json.url sermon_url(sermon, format: :json)
