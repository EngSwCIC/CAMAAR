module HomeHelper
  def nav_bar_content(action)
    puts action
    if action == 'company'
      "Company Space"
    elsif action == 'user_page'
      "User Space"
    else
      # statement
    end
  end
end
