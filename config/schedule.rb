every 1.day do
  runner "DailyDigestJob.perform_now"
end

every 60.minutes do
  rake "ts:index"
end