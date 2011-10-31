module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  def current_user?(user)
    user == self.current_user
  end

  def authenticate
  # flash[:notice] = 'Please sign in to access this page.'
  # The assignment above is included in the line below
   deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => 'Please sign in to access this page.'
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default, dict = nil)
    redirect_to(session[:return_to] || default)
    if (!dict.nil?)
      dict.each do |key , value|
        flash[key] = value
      end
    end

    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def flash_permission_denied
    flash[:error] = 'Permission denied!'
  end

private

  def user_from_remember_token
    # The star below essentially unwraps one layer of the variable, in this case an array
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
end
