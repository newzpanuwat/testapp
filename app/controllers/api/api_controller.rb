class Api::ApiController < ApplicationController
  include ActionController::MimeResponds
  
  before_action :authenticate_user!
  
  def render_ok(data = {})
    render status: :ok, json: data
  end

  def render_created(data = {})
    render status: :created, json: data
  end

  def render_bad_request(data = {})
    render status: :bad_request, json: data
  end

  def render_not_found(data = { message: 'not found' })
    render status: :not_found, json: data
  end

  def errors_msg(data = {})
    data.errors.full_messages.join
  end
end
