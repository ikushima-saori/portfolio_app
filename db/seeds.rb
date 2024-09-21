# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = '123456'
end


one = Customer.find_or_create_by!(email: '1@test.com') do |customer|
  customer.name = '一郎'
  customer.password = '111111'
  customer.password_confirmation = '111111'
  customer.preference = 'おじさん至上主義者'
  customer.weak = 'おじさんが若者に未来を託して退場する流れ'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_01.jpg"), filename: "number_01.jpg")
end

two = Customer.find_or_create_by!(email: '2@test.com') do |customer|
  customer.name = '二郎'
  customer.password = '222222'
  customer.password_confirmation = '222222'
  customer.preference = 'ポケモン'
  customer.weak = 'グロい描写が多いやつ'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_02.jpg"), filename: "number_02.jpg")
end

three = Customer.find_or_create_by!(email: '3@test.com') do |customer|
  customer.name = '三郎'
  customer.password = '333333'
  customer.password_confirmation = '333333'
  customer.preference = 'のんのんびより'
  customer.weak = '死ネタ'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_03.jpg"), filename: "number_03.jpg")
end

four = Customer.find_or_create_by!(email: '4@test.com') do |customer|
  customer.name = '四郎'
  customer.password = '444444'
  customer.password_confirmation = '444444'
  customer.preference = '蟲師'
  customer.weak = '三角関係'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_04.jpg"), filename: "number_04.jpg")
end

five = Customer.find_or_create_by!(email: '5@test.com') do |customer|
  customer.name = '五郎'
  customer.password = '555555'
  customer.password_confirmation = '555555'
  customer.preference = '最遊記'
  customer.weak = 'いじめもの'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_05.jpg"), filename: "number_05.jpg")
end

six = Customer.find_or_create_by!(email: '6@test.com') do |customer|
  customer.name = '六郎'
  customer.password = '666666'
  customer.password_confirmation = '666666'
  customer.preference = '鋼の錬金術師'
  customer.weak = '詳しい医療描写'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_06.jpg"), filename: "number_06.jpg")
end

seven = Customer.find_or_create_by!(email: '7@test.com') do |customer|
  customer.name = '七郎'
  customer.password = '777777'
  customer.password_confirmation = '777777'
  customer.preference = '血界戦線'
  customer.weak = 'バッドエンド'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_07.jpg"), filename: "number_07.jpg")
end

eight = Customer.find_or_create_by!(email: '8@test.com') do |customer|
  customer.name = '八郎'
  customer.password = '888888'
  customer.password_confirmation = '888888'
  customer.preference = 'キノの旅'
  customer.weak = 'リアルな拷問シーン'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_08.jpg"), filename: "number_08.jpg")
end

nine = Customer.find_or_create_by!(email: '9@test.com') do |customer|
  customer.name = '九郎'
  customer.password = '999999'
  customer.password_confirmation = '999999'
  customer.preference = 'もやしもん'
  customer.weak = '人の言うことを聞かない時の少年探偵団'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_09.jpg"), filename: "number_09.jpg")
end

ten = Customer.find_or_create_by!(email: '0@test.com') do |customer|
  customer.name = '十郎'
  customer.password = '000000'
  customer.password_confirmation = '000000'
  customer.preference = 'スパロボ'
  customer.weak = 'ホラー系'
  customer.is_active = true
  customer.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/app/assets/images/number_10.jpg"), filename: "number_10.jpg")
end

tag1 = Tag.find_or_create_by!(word: "眼鏡")
tag2 = Tag.find_or_create_by!(word: "全員幸せ")
tag3 = Tag.find_or_create_by!(word: "かわいい")
tag4 = Tag.find_or_create_by!(word: "ライバル")
tag5 = Tag.find_or_create_by!(word: "もふもふ")
tag6 = Tag.find_or_create_by!(word: "いちゃいちゃ")
tag7 = Tag.find_or_create_by!(word: "日常")
tag8 = Tag.find_or_create_by!(word: "お花見")

 idea1 = Idea.find_or_create_by!(id: 1) do |i|
  i.introduction =  "おじさんが眼鏡を新調する・フレーム選びで店員さんとわちゃわちゃ"
  i.title =  "ぼやけた視界で見る景色"
  i.body =  "朝起きたら、目覚ましの代わりにレンズの外れたメガネが手の下にあった時の気持ちを20文字で答えよ。"
  i.is_active =  true
  i.customer_id = one.id
  i.tags << tag1
  i.tags << tag2
end

 idea2 = Idea.find_or_create_by!(id: 2) do |i|
  i.introduction =  "おじさんが猫を拾う・家族ともめて家出する"
  i.title =  "家を得た猫と家を無くした人間"
  i.body =  "かわいいから拾った。それ以上でも以下でもない。"
  i.is_active =  true
  i.customer_id = one.id
  i.tags << tag2
end

 idea3 = Idea.find_or_create_by!(id: 3) do |i|
  i.introduction =  "サトシがピカチュウとケンカする・初期・他の手持ちが奮闘する感じで全員進化前がいい"
  i.title =  "仲良しが一番"
  i.is_active =  true
  i.customer_id = two.id
  i.tags << tag2
  i.tags << tag3
end

idea4 = Idea.find_or_create_by!(id: 4) do |i|
  i.introduction =  "シゲルとオーキド博士が森で迷子になって野生に襲われたり戦ったりでじーちゃんに憧れる孫爆誕物語"
  i.is_active =  false
  i.customer_id = two.id
  i.tags << tag2
  i.tags << tag4
end

idea5 = Idea.find_or_create_by!(id: 5) do |i|
  i.introduction =  "具がみんなと絡む話"
  i.title =  "鍋の具は何にしよう"
  i.body =  "我はタヌキである。名は具。マジか。"
  i.is_active =  true
  i.customer_id = three.id
  i.tags << tag2
  i.tags << tag5

end

idea6 = Idea.find_or_create_by!(id: 6) do |i|
  i.introduction =  "化ギン・久々に帰ってきた平和時空・冬と雪"
  i.title =  "雪関係がいい"
  i.is_active =  false
  i.customer_id = four.id
  i.tags << tag2
  i.tags << tag6
end

idea7 = Idea.find_or_create_by!(id: 7) do |i|
  i.introduction =  "敵襲とかないマジで何もない休日・平和に過ごしてほしい"
  i.title =  "三蔵一行の平和(笑)な休日"
  i.body =  "三蔵の「ぶっ殺すぞテメェら！」から始めたい"
  i.is_active =  true
  i.customer_id = five.id
  i.tags << tag2
  i.tags << tag7
end

idea8 = Idea.find_or_create_by!(id: 8) do |i|
  i.introduction =  "過去話・悟空がめちゃくちゃ甘やかされてほしい・幸せにならんとおかしい"
  i.title =  "桜入れたい"
  i.is_active =  true
  i.customer_id = five.id
  i.tags << tag2
  i.tags << tag8
end