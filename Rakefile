require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

Rake::TestTask.new(name = :eden_int) do |t|
  t.libs << "test_eden"
  t.test_files = FileList['test/eden_integration_test.rb']
  t.verbose = true
end

Rake::TestTask.new(name = :eden) do |t|
  t.libs << "test_eden"
  t.test_files = FileList['test/eden_player_test.rb']
  t.verbose = true
end

task :default => :test
