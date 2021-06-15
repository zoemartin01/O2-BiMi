class DrinksController < ApplicationController
  def index
    @drinks = Drink.where(enabled: true).order(:name).find_all
  end

  def show
    @drink = Drink.find(params[:id])
    controller_dir = File.dirname(__FILE__)
    path = File.join(controller_dir, "..", "assets", "images", "quickbuy-qr", params[:id].to_s + "_1.png")
    unless File.exist?(path)
      create_qrcode(params[:id])
    end
    unless @drink.enabled
      redirect_to '/'
    end
  end

  private

  def create_qrcode(id)
    qrcode = RQRCode::QRCode.new("http://100.124.27.57:3000" + "/quickbuy/" + id.to_s + "/" + "1")

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 400
    )

    controller_dir = File.dirname(__FILE__)
    path = File.join(controller_dir, "..", "assets", "images", "quickbuy-qr", id.to_s + "_1.png")
    IO.binwrite(path, png.to_s)
  end
end
