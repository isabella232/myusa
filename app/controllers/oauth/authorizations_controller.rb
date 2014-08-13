class Oauth::AuthorizationsController < Doorkeeper::AuthorizationsController
  def create
    if params.has_key?(:profile)
      current_user.profile.tap do |profile|
        if !profile.update_attributes(profile_params)
          flash[:error] = profile.errors.full_messages.to_sentence
          redirect_to oauth_authorization_path(redirect_back_params)
          return
        end
      end
    end

    if params[:scope].is_a?(Array)
      params[:scope] = params[:scope].join(" ")
    end

    super
  end

  private

  def profile_params
    params.require(:profile).permit(Profile::FIELDS + Profile::METHODS)
  end

  def redirect_back_params
    params.slice(
      'client_id', 'redirect_uri', 'state', 'response_type'
    ).merge(scope: params[:original_scope])
  end
end