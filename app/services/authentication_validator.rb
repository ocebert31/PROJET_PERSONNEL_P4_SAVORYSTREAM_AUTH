class AuthenticationValidator
  def initialize(params)
    @params = params
  end

  def validate_common_fields
    if password_empty?
      { message: "Password cannot be empty", status: :unprocessable_entity }
    elsif email_empty?
      { message: "Email cannot be empty", status: :unprocessable_entity }
    elsif invalid_email_format?(@params[:email])
      { message: "The email format is not valid", status: :unprocessable_entity }
    elsif password_too_short?
      { message: "Password must be at least 6 characters long", status: :unprocessable_entity }
    end
  end

  def validate_register_fields
    if email_already_taken?
      { message: "The email has already been taken", status: :unprocessable_entity }
    elsif passwords_do_not_match?
      { message: "Passwords don't match", status: :unprocessable_entity }
    end
  end

  private

  def email_already_taken?
    User.exists?(email: @params[:email])
  end

  def passwords_do_not_match?
    @params[:password] != @params[:confirmPassword]
  end

  def password_empty?
    @params[:password].blank?
  end

  def password_too_short?
    @params[:password].length < 6
  end

  def email_empty?
    @params[:email].blank?
  end

  def invalid_email_format?(email)
    !(email =~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
  end
end
  