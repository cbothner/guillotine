module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(file: "layouts/#{layout}")
  end

  def lesc(text)
    LatexToPdf.escape_latex(text)
  end

  def user_is_dd?
    current_user == User.where("username = 'dd'")[0]
  end
end
