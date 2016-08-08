# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  # Define :user_model_name. This model will be used to grand badge if no
  # `:to` option is given. Default is 'User'.
  # config.user_model_name = 'User'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
  # config.current_user_method = 'current_user'
  Merit::Badge.create!(
    id: 1,
    name: "Noob",
    description: "Gained 500 exp",
    custom_fields: { difficulty: :bronze, url: "icons/green.png" }
  )
  Merit::Badge.create!(
    id: 2,
    name: "Warrior",
    description: "Gained 2000 exp",
    custom_fields: { difficulty: :silver, url: "icons/grey.png" }
  )
  Merit::Badge.create!(
    id: 3,
    name: "Veteran",
    description: "Gained 5000 exp",
    custom_fields: { difficulty: :gold, url: "icons/dark_yellow.png" }
  )
  Merit::Badge.create!(
    id: 4,
    name: "Start-up",
    description: "Gained 1000 gold",
    custom_fields: { difficulty: :bronze, url: "icons/green.png" }
  )
  Merit::Badge.create!(
    id: 5,
    name: "Merchant",
    description: "Gained 10000 gold",
    custom_fields: { difficulty: :silver, url: "icons/grey.png" }
  )
  Merit::Badge.create!(
    id: 6,
    name: "Mr.Rockefeller",
    description: "Gained 50000 gold",
    custom_fields: { difficulty: :gold, url: "icons/dark_yellow.png" }
  )
  Merit::Badge.create!(
    id: 7,
    name: "Lazybones",
    description: "You sit for too long!!",
    custom_fields: { difficulty: :bronze, url: "icons/blue.png" }
  )
end

# Create application badges (uses https://github.com/norman/ambry)
# badge_id = 0
# [{
#   id: (badge_id = badge_id+1),
#   name: 'just-registered'
# }, {
#   id: (badge_id = badge_id+1),
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# }].each do |attrs|
#   Merit::Badge.create! attrs
# end
