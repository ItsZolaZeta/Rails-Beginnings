module ApplicationHelper
  
    def isLoggedIn()   
      if(session[:user_id].present?)
        true
      else
        false
      end
    end

    def currentUser()
      if(session[:user_id].present?)
        user = session[:user_id]
      end
    end

end
