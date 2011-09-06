namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_wish_categories
    make_wish_items
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
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
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
