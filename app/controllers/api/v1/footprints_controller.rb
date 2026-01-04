class Api::V1::FootprintsController < ApplicationController
  def create
    @trip = current_user.trips.find_by(id: footprint_params[:trip_id])

    # ユーザー本人によるリクエストなのかチェック.find_byはnilを返す
    if @trip.nil?
      return render json: { errors: "不正なTripIDです" }, status: :unprocessable_entity
    end

    @footprint = @trip.footprints.build(footprint_params)

    if @footprint.save
      render json: { status: "success" }, status: :ok
    else
      Rails.logger.debug @footprint.errors.full_messages
      render json: { status: "error", errors: @footprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def bulk_create
    insert_data = footprints_data_list

    if insert_data.empty?
      return render json: { errors: "有効なデータがありません" }, status: :unprocessable_entity
    end

    target_trip_id = insert_data.first[:trip_id]
    @trip = current_user.trips.find_by(id: target_trip_id)

    # ユーザー本人によるリクエストなのかチェック.find_byはnilを返す
    if @trip.nil?
      return render json: { errors: "不正なTripIDです" }, status: :unprocessable_entity
    end

    Footprint.insert_all!(insert_data)

    render json: { status: "success", count: insert_data.length }, status: :ok
  rescue => e
    Rails.logger.error e.message
    render json: { error: "保存に失敗しました" }, status: :unprocessable_entity
  end

  private

  def footprint_params
    params.require(:footprint).permit(:trip_id, :latitude, :longitude, :recorded_at)
  end

  def footprints_data_list
    params.require(:footprints).filter_map do |fp|
      p = fp.permit(:trip_id, :latitude, :longitude, :recorded_at)

      # 一つでも空がある場合はスキップ
      if p[:trip_id].blank? || p[:latitude].blank? || p[:longitude].blank? || p[:recorded_at].blank?
        next nil
      end

      geohash = GeoHash.encode(p[:latitude], p[:longitude], Footprint::GEOHASH_PRECISION)

      p.merge(
        geohash: geohash,
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end
end
