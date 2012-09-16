class AddQuestion3toBetaQuestion < ActiveRecord::Migration
  def self.up
		add_column :beta_questions, :question3, :string
  end

  def self.down
		remove_column :beta_questions, :question3
  end
end
