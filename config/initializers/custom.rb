def logm ob
  Rails.logger ob if Rails.env.test?
  pp ob if Rails.env.test?
end
def keep_time n=1,&block
  s = Time.now
  yield
  e = Time.now
  t = e - s
  sleep n - t if n > t
end

#ENV["DOMAIN"] = '.lvh.me:3002' if Rails.env.development?

