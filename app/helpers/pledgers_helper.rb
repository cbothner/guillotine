module PledgersHelper
  def instructions_for_operators(&blk)
    content_tag(:p, :class => "instructions", &blk) if !user_is_dd?
  end
  def instructions_span_for_operators(&blk)
    content_tag(:span, :class => "instructions", &blk) if !user_is_dd?
  end
end
