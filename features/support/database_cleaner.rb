Before do
  DatabaseCleaner.start
  SigaaTestData.configure!
  ActionMailer::Base.deliveries.clear
end

After do
  DatabaseCleaner.clean
end
