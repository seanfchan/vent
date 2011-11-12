namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_users
    make_ventposts
    make_relationships

    
  end
end

def make_users
  admin = User.create!(:name => 'EampleUser',
                         :email => 'example@gmail.com',
                         :password => 'foobar',
                         :password_confirmation => 'foobar')
  admin.toggle!(:admin)
  99.times do |n|
    name = "#{Faker::Name.first_name}#{Faker::Name.last_name}"
    email = "example-#{n+1}@gmail.jp"
    password = 'password'
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_ventposts
  User.all(:limit => 6).each do |user|
    50.times do
      user.ventposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each do |followed|
    user.follow!(followed)
  end

  followers.each do |follower|
    follower.follow!(user)
  end
end