module PledgersHelper
  def instructions_for_operators(&blk)
    content_tag(:p, class: 'instructions', &blk) unless current_user == User.where(username: 'dd')[0]
  end

  def instructions_span_for_operators(&blk)
    content_tag(:span, class: 'instructions', &blk) unless current_user == User.where(username: 'dd')[0]
  end
end
