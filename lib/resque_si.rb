class ResqueSi
  @queue = "si"
  def self.perform
    Resque::Job.reserve('ts_delta').perform
  end
end
