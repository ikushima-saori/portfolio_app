module ApplicationHelper

  #デバイスメッセージ・バリデーションメッセージ・カスタムメッセージなどfrashに入る全てのメッセージにまとめて対応できる
  def display_flash_messages
    return "" if flash.empty?
    flash.map do |key, message|  #noticeやalertがkeyに格納され、メッセージ文はmessageに格納される
      content_tag(:div, class: "flash-message") do  #divタグを生成してクラス名を付ける「<div class="flash-message">」
        content_tag(:h6, message)  #h6タグを生成してmessageのみ表示する「<h6><%= message %></h6>」
      end
    end.join.html_safe  #join=配列のdivタグを1つにまとめる　html_safeが無いと表示されない　セットで必要
  end
end
