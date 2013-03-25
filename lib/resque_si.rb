class ResqueSi
  @queue = "si"
  def self.perform
    for i in 1..3 do
      job = Resque::Job.reserve('ts_delta')
      break if job.nil?
      job.perform
    end
  end
end
