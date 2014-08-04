class CreateLessonStatuses < ActiveRecord::Migration
  def change
    create_table :lesson_statuses do |t|
      t.string :name

      t.timestamps
    end

    add_column :lessons, :status, :integer
  end
end
