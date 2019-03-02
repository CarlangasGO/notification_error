class NotificationError

	def self.config_firestore(credentials)

		require "google/cloud/firestore"

    Google::Cloud::Firestore.configure do |config|
      config.project_id  = "control-errores-2"
      config.credentials = credentials
    end
  end

  def self.config_extras(fcm_key, mailgun_key, email_to)

  	@fcm_key = fcm_key

  	@mailgun_key = mailgun_key

  	@email_to = email_to

  end

  def self.process_notification(collection, domain, summary, message, push_notification=false, email_notification=false)

  	require "google/cloud/firestore"

    firestore = Google::Cloud::Firestore.new

    table = firestore.collection(collection)

    random_ref =  table.add({ domain: domain, summary: summary, message: message, register_at: Time.now.in_time_zone("Madrid") })

    #Rails.logger.warn "NOTIFICATION-ERROR: #{random_ref.inspect}"

    fcm_message = "#{domain} #{summary}"

    if push_notification
      send_notification(fcm_message)
    end

    mailgun_message = "#{domain}<br><br>#{summary}<br><br>#{message}"

    subject = "ERROR #{fcm_message}"

    if email_notification
    	mail_send(subject, mailgun_message)
    end

  end

	def self.send_notification(message)
	  require 'fcm'
	  
	  options = {data: {message: message}, priority: 'high', notification: {body: message, badge: 1, sound: "default", icon: "ic_close_dark"}, content_available: true}

	  fcm = FCM.new(@fcm_key) 

	  response = fcm.send_to_topic("matricula", options)

		#Rails.logger.warn "NOTIFICATION-ERROR: #{response.inspect}"
	end

	def self.mail_send(subject, content)
		require 'mailgun-ruby'
		
	  mg_client = Mailgun::Client.new @mailgun_key
	  # Define your message parameters
	  message_params = {:from    => "javier@expansia.es",
	                    :to      => @email_to,
	                    :subject => "#{subject}",
	                    :text    => "#{content}",
	                    :html => "#{content}"}

	  envio = mg_client.send_message "expansia.es", message_params

	  #Rails.logger.warn "NOTIFICATION-ERROR: #{envio.inspect}"

	end

end