class PinlistController < ApplicationController
    def create
        user = User.find(params[:user_id])
        pin = Pin.find(params[:pin_id])

        user.pinlist << pin # will automatically save!
        
        redirect_to pin_path(pin)
    end

    def index
        user = User.find(params[:user_id])
        @pinlist = user.pinlist
    end
end
