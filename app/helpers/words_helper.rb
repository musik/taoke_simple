module WordsHelper
  def fake_img url
    "/static/#{url.match(/\/([^\/]+?)_90x90.jpg/)[1]}"
  end
end
