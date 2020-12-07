require "multi_auth"

# MultiAuth.config("facebook", "facebookClientID", "facebookSecretKey")
MultiAuth.config("google", ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"])

def self.multi_auth(env)
  provider = env.params.url["provider"]
  # redirect_uri = "#{Kemal.config.scheme}://#{env.request.host_with_port.as(String)}/multi-auth/#{provider}/callback"
  redirect_uri = "#{ENV["SCHEME"]? || "http"}://#{env.request.host_with_port.as(String)}/multi-auth/#{provider}/callback"
  MultiAuth.make(provider, redirect_uri)
end
