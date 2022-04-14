class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in sucessfully.'},
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
  end
  
  def log_out_failure
    render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
  end
end