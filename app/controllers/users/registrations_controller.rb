class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    resource.persisted? ? register_success : register_failed
  end

  def register_success
    render json: {
        message: "Signed up sucessfully.",
        status: 200,
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
  end
  
  def register_failed
    render json: {
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}",
        status: 403
      }
  end
end