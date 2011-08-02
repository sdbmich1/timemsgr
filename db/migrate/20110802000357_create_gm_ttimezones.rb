class CreateGmTtimezones < ActiveRecord::Migration
  def self.up
    create_table :gmttimezones, :force => false do |t|
      t.float :code
      t.float :code2

      t.timestamps
    end
  end

  def self.down
    drop_table :gmttimezones
  end
end
