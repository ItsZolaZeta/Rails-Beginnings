class HomeController < ApplicationController
    def index
        @pins = Pin.most_recent
      end
end
