class CustomFailure < Devise::FailureApp
    def redirect_url
        if @scope_class == Quran::CoreUser
            '/quran/admin/login'
        else
            '/quran/auth/login' # Quran::CoreAccount
        end
    end

    def respond
        if http_auth?
            http_auth
        else
            redirect
        end
    end
end