module Pulse
  module Views
    module Helpers
      module CSRF
        extend self
  
        def csrf_input_tag(env)
          # "<meta name=\"csrf-token\" content=\"#{env.session.string("csrf")}\">"
          "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{env.session.string("csrf")}\">"
        end
      end
    end
  end
end