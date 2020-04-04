class Api::V1::ServicesController < ApplicationController
  def index
    render json: {data: [1,2,3]}, status: :ok
  end
end
