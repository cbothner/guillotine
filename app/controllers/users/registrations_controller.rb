class Users::RegistrationsController < Devise::RegistrationsController
  def create
    secret = params[:user].delete(:secret)
    @user = User.new(params[:user])

    if secret == 'jlambers'
      if @user.save
        flash[:notice] = 'Registered successfully!'
        sign_in_and_redirect(User, @user)
      else
        render action: :new
      end
    else
      flash[:notice] = 'Secret is incorrect.'
      render action: :new
    end
  end
end
