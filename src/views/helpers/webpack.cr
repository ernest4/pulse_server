module Pulse
  module Views
    module Helpers
      module Webpack
        extend self
    
        def stylesheet_pack_tag(name)
          hashed_file_name = Dir["public/app/css/*.css"].first.split("/").last
    
          "<link href=\"/app/css/#{hashed_file_name}\" rel=\"stylesheet\">"
        end
    
        def javascript_pack_tag(name)
          hashed_file_name = Dir["public/app/js/*.js"].first.split("/").last
    
          "<script src=\"/app/js/#{hashed_file_name}\"></script>"
        end
    
        # def csrf_meta_tags(env)
        #   "<meta name=\"csrf-token\" content=\"#{env.session.string("csrf")}\">"
        # end
      end
    end
  end
end