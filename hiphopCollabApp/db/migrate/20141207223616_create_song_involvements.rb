class CreateSongInvolvements < ActiveRecord::Migration
  def change
    create_table :song_involvements do |t|

    	t.integer :song_id
    	t.integer :artist_id
    	t.boolean :primary
    	t.boolean :featured
    	t.boolean :producer

      t.timestamps
    end
  end
end
