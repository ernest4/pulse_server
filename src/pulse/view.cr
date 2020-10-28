# TODO: specs ??

module Pulse
  module View
    extend self

    VIEW_PREFIX = "src/pulse/views"
    LAYOUT_PREFIX = "#{VIEW_PREFIX}/layouts"

    def view(file_path)
      "#{VIEW_PREFIX}#{file_path}"
    end

    def layout(file_path)
      "#{LAYOUT_PREFIX}#{file_path}"
    end
  end
end
