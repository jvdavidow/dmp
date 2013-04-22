require 'faker'

rand(10..30).times do
  p = Post.create(title: Faker::Lorem.words(rand(1..10)), body: Faker::Lorem.paragraphs(rand(1..4)))

  rand(3..10).times do
    p.comments.create(body: Faker::Lorem.paragraphs(rand(1..2)))
  end
end

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
