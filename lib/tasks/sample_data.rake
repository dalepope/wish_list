namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_wish_categories
    make_wish_items
    make_draw_exclusions
  end
end

def make_users
  admin = User.create!(:name => "Example User",
                       :email => "example@dummy.org",
                       :password => "foofoobarbar",
                       :password_confirmation => "foofoobarbar")
  admin.toggle!(:admin)
  20.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@dummy.org"
    password  = "foofoobarbar"
    user = User.new(:name => name,
             :email => email,
             :password => password,
             :password_confirmation => password)
    user.toggle!(:in_draw) unless name =~ /[S-Z]/
    user.save!
  end
end

def make_wish_categories
  WishCategory.create!(:name => "none")
end

def make_wish_items
  categories = WishCategory.all
  User.all.each do |user|
    10.times do |i|
      description = Faker::Lorem.sentence(5)
      url = "http://#{Faker::Internet.domain_name}"
      category = categories[0]
      WishItem.create!(:description => description,
                       :url => url,
                       :category_id => category.id,
                       :user_id => user.id)
    end
  end
end

def make_draw_exclusions
  users = User.all
  excluding = users[8..15]
  users[0..7].each do |user|
    excluding.each { |x| user.draw_exclude!(x) if user.in_draw && x.in_draw }
    excluding.pop
  end
end
