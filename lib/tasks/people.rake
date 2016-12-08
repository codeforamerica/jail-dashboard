namespace :people do
  desc 'import people data from flat file'
  task import: :environment do
    require 'csv'

    Person.transaction do
      puts 'reading people'
      # This is a temporary path for the CSV; just wanted to get things up and running, will replace once ETL process more clearly defined
      people = CSV.read("#{Rails.root}/tmp/people.csv")
      columns = [:jms_person_id, :first_name, :middle_name, :last_name, :date_of_birth, :gender, :race]
      Person.import columns, people, validate: false
      puts 'people imported'
    end
  end

  desc 'generate people'
  task :generate, [:count] => [:environment] do |_, args|
    count = (args[:count] || 10).to_i

    puts "Generating #{count} people..."
    Person.transaction do
      count.times do
        Person.create!(
          jms_person_id: Faker::Code.isbn,
          first_name: Faker::Name.first_name,
          middle_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          date_of_birth: Faker::Time.between(70.years.ago, 18.years.ago),
          gender: Person::GENDERS.sample,
          race: Person::RACES.sample
        )
      end
    end
    puts "Successfully generated #{count} people"
  end
end
