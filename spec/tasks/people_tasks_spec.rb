require 'rails_helper'
require 'rake'

describe 'people rake tasks' do
  describe 'people:generate' do
    include_context 'rake'

    let(:task_name) do
      'people:generate'
    end

    it 'creates 10 people by default' do
      expect { run_task }.to change { Person.count }.by(10)
    end

    it 'accepts number of people to create as argument' do
      expect { run_task('3') }.to change { Person.count }.by(3)
    end

    it 'assigns age higher than 18 years' do
      run_task('3')

      people_ages = Person.last(3).map(&:date_of_birth)

      expect(people_ages.first).to be < 18.years.ago
      expect(people_ages.second).to be < 18.years.ago
      expect(people_ages.third).to be < 18.years.ago
    end

    it 'assigns existing gender' do
      run_task('3')

      actual_genders = Booking.last(3).map(&:gender)

      expect(Person::GENDERS).to include(*actual_genders)
    end

    it 'assigns existing race' do
      run_task('3')

      actual_races = Booking.last(3).map(&:race)

      expect(Person::RACES).to include(*actual_races)
    end
  end
end
