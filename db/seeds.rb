require "faker"
# seed users
9.downto(0) do
  # users
  new_user = Faker::Company.name.split("-")
  last_name = new_user.last
  first_name = new_user.first
  user = User.new
  user.email = Faker::Internet.email(name: (first_name+ ' ' + last_name))
  user.password = Faker::Internet.password
  user.save
  profile = Profile.new
  profile.user_id = user.id
  profile.display_name = Faker::Internet.username(specifier: (first_name+ ' ' + last_name))
  profile.bio = Faker::Fantasy::Tolkien.poem
  profile.location = Faker::Fantasy::Tolkien.location
  profile.save
end

# seed posts
all_users = User.all
all_users.each do |user|
  rand(10).downto(0) do
    Post.create!(
      user_id: user.id,
      content: Faker::Books::Dune.quote
    )
  end
end

# seed comments and likes
all_posts = Post.all
all_posts.each do |post|
  # comments
  all_users.each do |user|
    next if user.id == post.user_id
    next if rand(2) == 0
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
    next if rand(2) == 0
    FollowRequest.create!(
      follower_id: user.id,
      followee_id: other_user.id, # check your column name!
      status: %i[pending accepted declined].sample
    )
  end
end

# superuser that can see all the posts
superuser = User.create!(email: 'super@user.com', password: 'password')
Profile.create!(
  user_id: superuser.id,
  display_name: "superuser",
  bio: Faker::Books::Dune.quote,
  location: Faker::Books::Dune.planet
)
all_users.each do |user|
  FollowRequest.create!(
    follower_id: superuser.id,
    followee_id: user.id,
    status: 1
  )
end
