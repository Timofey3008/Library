class SimpleJob
  @queue = :simple

  def self.perform
    # здесь делаем важные и полезные вещи

        puts "Job is done"
  end
end