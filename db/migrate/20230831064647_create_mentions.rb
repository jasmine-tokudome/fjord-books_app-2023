class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.bigint :mentioning_report_id, index: true, foreign_key: true
      t.bigint :mentioned_report_id, index: true, foreign_key: true

      t.timestamps
    end

    add_foreign_key :mentions, :reports, column: :mentioning_report_id
    add_foreign_key :mentions, :reports, column: :mentioned_report_id
  end
end
