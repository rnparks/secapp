Rake::TestTask.new(:real_world_benchmark => ['test:benchmark_mode']) do |t|
  t.libs << 'test'
  t.pattern = 'test/performance/**/*_test.rb'
end
