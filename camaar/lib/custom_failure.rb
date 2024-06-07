class CustomFailure < Devise::FailureApp
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect
    store_location!
    if request.format == :json
      render json: { error: 'Unauthorized' }, status: :forbidden
    else
      redirect_to root_path
    end
  end
end
