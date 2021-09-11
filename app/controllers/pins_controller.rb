class PinsController < ApplicationController
    def index
        @pins = Pin.all
    end

    def search
        @search_term = params[:q]
        logger.info("Search completed using #{@search_term}.")
        @pins = Pin.search(@search_term)
    end

    def new
        @pin = Pin.new
    end

    def create
        user = User.find(session[:user_id])
        @pin = Pin.new(pins_resource_params)
        @pin.user = user

        if(@pin.save)
            redirect_to pins_path
        else 
            render 'new'  
        end
    end

    def show
        @pin = Pin.find(params[:id])
        @comment = Comment.new
        @display_add_comment = session[:user_id].present?

        if(session[:user_id].present?)
            @user = User.find(session[:user_id])
            @disable_add_pinlist = @user.pinlist.exists?(@pin.id)
        else
            @user = nil
        end
    end

    def edit
        id = params[:id]
        @pin = Pin.find(id)
    end

    def update
        @pin = Pin.find(params[:id])
        if(@pin.update(pins_resource_params))
            redirect_to pins_path
        else
            render 'edit'
        end
    end

    private 
    def pins_resource_params
        params.require(:pin).permit(:title, :image_url, :tag)
    end
end
