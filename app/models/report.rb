# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable
end
