module DonationsHelper
  def unsorted_grouped_options_for_select(grouped_options, selected_key = nil, prompt = nil)
    body = ''
    body << content_tag(:option, prompt, { value: '' }, true) if prompt

    grouped_options.each do |group|
      body << content_tag(:optgroup, options_for_select(group[1], selected_key), label: group[0])
    end

    body.html_safe
  end
end
