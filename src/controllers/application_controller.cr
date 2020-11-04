# TODO: specs !?!?

module Pulse
  class ApplicationController
    macro pulse_render(view, layout = nil)
      {% base_view_path = "src/views" %}
    
      {% if layout == nil %}
        render "#{{{base_view_path}}}/#{{{view}}}.ecr"
      {% else %}
        render "#{{{base_view_path}}}/#{{{view}}}.ecr", "#{{{base_view_path}}}/layouts/#{{{layout}}}.ecr"
      {% end %}
    end

    macro render_json(hash)
      env.response.content_type = "application/json"

      {{hash}}.to_json
    end
  end
end
