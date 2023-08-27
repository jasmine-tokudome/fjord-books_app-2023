# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :comments, dependent: :destroy, as: :commentable

  mount_uploader :picture, PictureUploader
end
