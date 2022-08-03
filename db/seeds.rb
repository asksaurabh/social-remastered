# Create a main sample user.
User.create!( firstname:  "Saurabh",
              lastname: "Kumar",
              email: "devhere101@gmail.com",
              password:              "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now)

# Generate a bunch of additional users.
99.times do |n|
  firstname = Faker::Name.first_name
  lastname = Faker::Name.last_name
  email = "example-#{n + 1}@gmail.com"
  password = "password"
  User.create!(firstname:  firstname,
               lastname: lastname, 
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Generate 50 microposts for first 6 users.
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Create following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each do |other_user|
  user.follow(other_user)
end
followers.each do |other_user|
  other_user.follow(user)
end