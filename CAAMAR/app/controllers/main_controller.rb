class MainController < ApplicationController
    def index
        unless helpers.is_user_admin(nil)
            redirect_to "/"
            return
        end
        @templates = Template.all
    end
end
