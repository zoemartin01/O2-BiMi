module ApplicationHelper
  def drinks
    Drink.where(enabled: true).order(:name).find_all
  end

  def users
    User.where(enabled: true).order(:name).find_all
  end

  def host
    request.host_with_port
  end
end
