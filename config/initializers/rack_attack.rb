class Rack::Attack
  throttle('api/v1/urls/encode', limit: 30, period: 1.minute) do |req|
    if req.path == '/api/v1/encode' && req.post?
      req.ip
    end
  end

  throttle('api/v1/urls/decode', limit: 30, period: 1.minute) do |req|
    if req.path == '/api/v1/decode' && req.get?
      req.ip
    end
  end

  self.throttled_response = lambda do |_env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Rate limit exceeded. Try again later.' }.to_json]
    ]
  end
end
