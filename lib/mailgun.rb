module Mailgun
  class << self
    API_KEY = BulletForge.mailgun_api_key
    DOMAIN  = BulletForge.mailgun_domain

    def send_password_reset user
      send_email({
        "to"      => user.email,
        "from"    => "BulletForge <no-reply@bulletforge.org>",
        "subject" => "Your Password Reset Request",
        "text"    => password_reset_email_body(user)
      })
    end

    def send_user_message sender, recipient, message
      send_email({
        "to"         => recipient.email,
        "from"       => "BulletForge <no-reply@bulletforge.org>",
        "subject"    => "Message from #{sender.login}",
        "text"       => user_message_email_body(sender, message),
        "h:Reply-To" => sender.email
      })
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

    def send_email opts
      request = Net::HTTP::Post.new("/v3/#{DOMAIN}/messages")
      request.basic_auth("api", API_KEY)
      request.set_form_data(opts)

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

    def user_message_email_body sender, message
      <<-END
You have a received a message from #{sender.login}.
You can reply to the user by replying to this email.

----

#{message}
      END
    end
  end
end