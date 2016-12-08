require "rake"

shared_context "rake" do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/#{task_name.split(":").first}" }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  def run_task(args = nil, verbose: false)
    if verbose
      Rake::Task[task_name].invoke(args)
    else
      silence_stream(STDOUT) do
        Rake::Task[task_name].invoke(args)
      end
    end
  end

  before(:each) do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
    Rake::Task[task_name].reenable
  end
end
