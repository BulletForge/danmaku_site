# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def order_by(link_name, order_name)
    if params[:order] == order_name + " ASC"
      order_name += " DESC"
      link_name += "↑"
    elsif params[:order] == order_name + " DESC"
      order_name += " ASC"
      link_name += "↓"
    else
      order_name += " ASC"
    end
    link_to link_name, params.merge(:order => order_name)
  end
end