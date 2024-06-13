class TemplatesController < ApplicationController
  include AuthenticationConcern
    def index
        if self.user_authenticated
            @templates = Template.all
        end
    end
end
