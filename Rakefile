require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test_eden" # t.libs << "test"
  t.test_files = FileList['test/eden_player_test.rb'] # t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :eden do
  Rake::TestTask.new do |t|
    t.libs << "test_eden"
    t.test_files = FileList['test/eden_player_test.rb']
    t.verbose = true
  end
end

task :default => :test
