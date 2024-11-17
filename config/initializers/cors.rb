# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://url-shortener-fe-3fd619189a11.herokuapp.com"

    resource "/api/v1/encode",
      headers: :any,
      methods: [:post, :options]
    resource "/api/v1/decode",
      headers: :any,
      methods: [:get, :options]
  end
end
