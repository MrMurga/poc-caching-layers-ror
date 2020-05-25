class ApplicationController < ActionController::Base
    def index
        render plain: 'ok'
    end
end
