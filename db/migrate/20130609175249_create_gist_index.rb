class CreateGistIndex < ActiveRecord::Migration
  def up
    execute 'CREATE INDEX trgm_index ON pledgers USING gist (name gist_trgm_ops)'
  end

  def down
    execute 'DROP INDEX trgm_index'
  end
end
