module Pulse
  module Views
    extend self

    def stylesheet_pack_tag(name)
      hashed_file_name = Dir["public/app/**/*.css"].first.split("/").last

      "<link href=\"/app/css/#{hashed_file_name}\" rel=\"stylesheet\">"
    end

    def javascript_pack_tag(name)
      hashed_file_name = Dir["public/app/**/*.js"].first.split("/").last

      "<script src=\"/app/js/#{hashed_file_name}\"></script>"
    end
  end
end