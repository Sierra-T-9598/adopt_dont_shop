class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :applicant_name
      t.string :address
      t.string :description

      t.timestamps
    end
  end
end
