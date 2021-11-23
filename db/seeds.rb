%w[
  Single
  Plural
  Stage
  Full Game
  Player
  Library
  Shot Definition
].each do |category|
  Category.find_or_create_by!(name: category)
end

%w[
  0.12m
  ph3
  woo
  ph3sx
  r:dnh
].each do |engine|
  DanmakufuVersion.find_or_create_by!(name: engine)
end

User.find_by(login: 'Blargel') || User.create!(
  login: 'Blargel',
  email: 'LargeBagel@gmail.com',
  password: 'asdfjkl;',
  password_confirmation: 'asdfjkl;',
  admin: true
)
