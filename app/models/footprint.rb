class Footprint < ApplicationRecord
  # バリデーション定義
  validates :trip_id, :latitude, :longitude, :geohash, :recorded_at, presence: true

  # アソシエーション定義
  belongs_to :trip

  # 初期値定義
  # 記録時刻はアプリ側の時間を入れる
  attribute :recorded_at, :datetime, default: -> { Time.current }
end
