module Mailgun
  class << self
    API_KEY = BulletForge.mailgun_api_key
    DOMAIN  = BulletForge.mailgun_domain

    def send_password_reset user
      send_email(
        user.email,
        "BulletForge <no-reply@bulletforge.org>",
        "Your Password Reset Request",
        password_reset_email_body(user)
      )
    end

    private

    def http
      return @http if @http

      @http = Net::HTTP.new("api.mailgun.net", 443)
      @http.use_ssl = true
      # Unsafe, but who cares, this is a hobby project.
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      @http
    end

    def send_email to, from, subject, body
      request = Net::HTTP::Post.new("/v3/#{DOMAIN}")
      request.basic_auth("api", API_KEY)
      request.set_form_data({
        "to"      => to,
        "from"    => from,
        "subject" => subject,
        "text"    => body
      })

      response = http.request(request)
      response.kind_of?(Net::HTTPSuccess)
    end

    def password_reset_email_body user
      <<-END
Hello #{user.login},

To reset your password, please click on the link below:
http://www.bulletforge.org/reset_password?token=#{user.password_token}

The link will stop working after a successful reset or after 24 hours have passed.
If you did not request a password reset, you may safely disregard this email.
      END
    end
  end
end