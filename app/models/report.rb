# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentioning, class_name: 'Mention', foreign_key: :mentioning_report_id, dependent: :destroy, inverse_of: :mentioning_report
  # has_many :mentioning_reports, through: :mentioning
  has_many :mentioned, class_name: 'Mention', foreign_key: :mentioned_report_id, dependent: :destroy, inverse_of: :mentioned_report
  # has_many :mentioned_reports, through: :mentioned

  validates :title, presence: true
  validates :content, presence: true

  after_save do
    matching_mentions = Mention.where(mentioning_report: self)
    matching_mentions.destroy_all
    extract_urls = self[:content].scan(%r{http://localhost:3000/reports/([^0]\d+)}).uniq.flatten
    if extract_urls.any?
      extract_urls.each do |extract_url|
        mentioning.create(mentioned_report_id: extract_url)
      end
    end
  end

  after_destroy do
    # binding.irb
    matching_mentioning = Mention.where(mentioning_report: self)
    Mention.destroy(matching_mentioning.ids)
    matching_mentioned = Mention.where(mentioned_report: self)
    Mention.destroy(matching_mentioned.ids)
  end

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
