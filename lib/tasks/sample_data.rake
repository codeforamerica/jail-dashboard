namespace :sample_data do
  desc 'generate sample data'
  task :generate, [:count] => ['people:generate', 'bookings:generate_weekly']
end
