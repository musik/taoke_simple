module ShopsHelper
  def shop_url shop
    shop_home_url(shop.sid.to_s(36),:subdomain=>Settings.shop_domain)
  end
end
