# Create a main sample user.
User.create!( firstname:  "Saurabh",
              lastname: "Kumar",
              email: "devhere101@gmail.com",
              password:              "foobar",
              password_confirmation: "foobar",
              admin: true)

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
               password_confirmation: password)
end