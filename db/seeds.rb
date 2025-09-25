require "faker"
require "open-uri"
# seed users
9.downto(0) do
  # users
  new_user = Faker::Company.name.split("-")
  last_name = new_user.last
  first_name = new_user.first
  user = User.create!(
  email: Faker::Internet.email(name: (first_name+ ' ' + last_name)),
  password: Faker::Internet.password
  )
  profile = Profile.find_by(user_id: user.id)
  profile.display_name = Faker::Internet.username(specifier: (first_name+ ' ' + last_name))
  profile.bio = Faker::Fantasy::Tolkien.poem
  profile.location = Faker::Fantasy::Tolkien.location
  profile.save!
  next if rand(2) == 0
  begin
    profile_image = URI.open(Faker::Avatar.image)
    profile.avatar.attach(io: profile_image, filename: "avatar-#{user.id}.png", content_type: "image/png")
  rescue OpenURI::HTTPError => e
    puts "Skipping random avatar for user #{user.id}: #{e.message}"
  end
end

# declare all_users for comments and likes
all_users = User.all

# seed posts
all_users.each do |user|
  rand(10).downto(0) do
    post = Post.create!(
      user_id: user.id,
      content: Faker::Books::Dune.quote
    )
    next if rand(5) == 0
    begin
      post_image = URI.open(Faker::Avatar.image)
      post.image.attach(io: post_image, filename: "image-#{post.id}.png", content_type: "image/png")
    rescue OpenURI::HTTPError => e
      puts "Skipping random image for post #{post.id}: #{e.message}"
    end
  end
end

# seed comments and likes
all_posts = Post.all
all_posts.each do |post|
  # comments
  all_users.each do |user|
    next if user.id == post.user_id
    next unless rand(5) == 0
    Comment.create!(
      body: Faker::Fantasy::Tolkien.poem,
      user_id: user.id,
      post_id: post.id
    )
  end
  # likes
  all_users.each do |user|
    next if user.id == post.user_id
    next if rand(2) == 0
    Like.create!(
      user_id: user.id,
      post_id: post.id
    )
  end
end

# seed follow requests
all_users.each do |user|
  all_users.each do |other_user|
    next if user.id == other_user.id
    next unless rand(5) == 0
    FollowRequest.create!(
      follower_id: user.id,
      followee_id: other_user.id, # check your column name!
      status: %i[pending accepted declined].sample
    )
  end
end

# superuser that can see all the posts
superuser = User.create!(email: 'super@user.com', password: 'password')
profile = Profile.find_by(user_id: superuser.id)
profile.display_name= "superuser"
profile.bio= Faker::Books::Dune.quote
profile.location= Faker::Books::Dune.planet
profile.save
all_users.each do |user|
  next if user.id == superuser.id
  FollowRequest.create!(
    follower_id: superuser.id,
    followee_id: user.id,
    status: "accepted"
  )
end
