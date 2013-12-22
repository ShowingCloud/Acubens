# This migration comes from refinery_faqs (originally 1)
class CreateFaqsFaqs < ActiveRecord::Migration

  def up
    create_table :refinery_faqs do |t|
      t.string :question
      t.text :answer
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-faqs"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/faqs/faqs"})
    end

    drop_table :refinery_faqs

  end

end
