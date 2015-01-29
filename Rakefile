require File.expand_path('../application', __FILE__)
require 'rake'

desc " Update the es store, daily task"
task :update_store  do
  puts "Updating ..."
  UpdateStore.execute
  puts "done."
end

desc 'Prepare the elasticsearch store'
task :bootstrap  do
  FoodTruck.create_index!
end