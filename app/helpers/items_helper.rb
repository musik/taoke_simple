module ItemsHelper
  def local_path url
    ActionController::Base.asset_host + url.sub(/http:\/\/img(\d+).taobaocdn.com\/bao\/uploaded\/i(\d)/,'/img/\1/\2')
  end
end
