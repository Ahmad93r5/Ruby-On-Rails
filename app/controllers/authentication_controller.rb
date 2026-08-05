class AuthenticationController < ApplicationController

  # POST /signup
  def signup
    user = User.new(user_params)

    if user.save
      render json: {
        message: "User Registered Successfully"
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        token: token
      }, status: :ok
    else
      render json: {
        error: "Invalid Email or Password"
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end