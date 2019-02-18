json.extract! credential, :id, :name, :description, :url, :login, :password, :server_type, :in_use, :default, :created_at, :updated_at
json.url credential_url(credential, format: :json)
