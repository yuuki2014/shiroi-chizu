class TutorialsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
