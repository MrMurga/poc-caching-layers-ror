class ApplicationController < ActionController::Base
    def index
        render template: 'render_content', locals: { description: '', content: '' }
    end
end
