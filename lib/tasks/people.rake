namespace :people do
  desc "import people data from flat file"
  task import: :environment do
    require 'csv'

    Person.transaction do
      puts "reading people"
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      people = CSV.read("#{Rails.root}/tmp/people.csv")
      columns = [:jms_person_id, :first_name, :middle_name, :last_name, :date_of_birth, :gender, :race]
      Person.import columns, people, validate: false
      puts "people imported"
    end
  end
end
