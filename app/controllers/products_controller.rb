# frozen_string_literal: true

require 'csv'

class ProductsController < ApplicationController
  before_action :set_file_product, only: :batch_create
  before_action :check_file, only: :batch_create

  def index; end

  def import; end

  def batch_create
    products = Array.new()
    errors = Array.new()

    file = File.open(@file_product)
    csv = CSV.parse(file, headers: true)

    csv.each_with_index do |row, index|
      begin
        next errors << {row: index + 1, error: "Data at row #{index+1} is empty."} if row[0].nil?
        
        products << { name: row[0], sku: row[2], price: row[1] }
      rescue StandardError => error
        redirect_to products_path, alert: "Import failed: #{error.message}"
      end
    end

    Product.insert_all!(products)
    
    redirect_to root_path
  end

  private

  # Prevent file is empty or not csv
  def check_file
    redirect_to import_products_path if @file_product.nil? || @file_product.content_type != 'text/csv'
  end

  def set_file_product
    @file_product = params[:file_product]
  end
end