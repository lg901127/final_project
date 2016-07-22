["Strength", "Constitution", "Luck"].each do |name|
  Stat.create name: name
end
# 10.times do
#   q = Item.create name:      Faker::Commerce.product_name,
#                   description:       Faker::Lorem.sentence
# end
