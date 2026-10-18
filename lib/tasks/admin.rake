namespace :admin do
  desc "Create the first administrator from ADMIN_EMAIL and ADMIN_PASSWORD"
  task create: :environment do
    email = ENV.fetch("ADMIN_EMAIL")
    password = ENV.fetch("ADMIN_PASSWORD")

    admin = AdminUser.create!(email: email, password: password, password_confirmation: password)
    puts "Created administrator #{admin.email}"
  end
end
