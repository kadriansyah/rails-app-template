module Admin
    class UserForm
        include ActiveModel::Model

        attr_accessor(
            :email,
            :username,
            :password,
            :confirmation_password,
            :firstname,
            :lastname
        )

        # Validations
        validates :email, presence: true
        validates :username, presence: true
        validates :password, presence: true
        validates :confirmation_password, presence: true

        def save
            if valid?
                core_user = Admin::CoreUser.new(email: self.email,
                                                username: self.username,
                                                password: self.password,
                                                firstname: self.firstname,
                                                lastname: self.lastname)
                core_user.save
                true
            else
                false
            end
        end
    end
end
