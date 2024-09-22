module Public::IdeasHelper
  #アイデアの作成日もしくは更新日を取得するメソッド
  def update_time_check(idea)
    if idea.updated_at.present?
      idea.updated_at.in_time_zone('Tokyo').strftime("%Y/%m/%d %H:%M")
    else
      idea.created_at.in_time_zone('Tokyo').strftime("%Y/%m/%d %H:%M")
    end
  end
end
