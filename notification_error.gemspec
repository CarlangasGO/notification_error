Gem::Specification.new do |s|
  s.name        = 'notification_error'
  s.version     = '0.0.2'
  s.date        = '2019-02-25'
  s.summary     = "Notification Error"
  s.description = "Invespromo"
  s.authors     = ["Carlos Montalvo"]
  s.email       = 'zephirotube@gmail.com'
  s.files       = ["lib/notification_error.rb"]
  s.homepage    = 'http://rubygems.org/gems/notification_error'
  s.license     = 'MIT'


  s.add_dependency("google-cloud-firestore", "~> 0.25.0")
  s.add_dependency("fcm", "~> 0.0.6")
  s.add_dependency("mailgun-ruby", "~>1.1.6")

end