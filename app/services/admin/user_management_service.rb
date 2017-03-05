module Admin
    class UserManagementService
        def create_user(user_form)
            user_form.save
        end
    end
end