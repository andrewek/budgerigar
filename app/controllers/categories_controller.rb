# frozen_string_literal: true

class CategoriesController < ApplicationController
  def create
    result = Categories::Create.new(params: params).perform
    rendur result
  end

  def show
    result = Categories::Fetch.new(params: params).perform
    rendur result
  end

  def index
    result = Categories::List.new(params: params).perform
    rendur result
  end

  def update
    result = Categories::Update.new(params: params).perform
    rendur result
  end

  def destroy
    result = Categories::Destroy.new(params: params).perform
    rendur result
  end

  def allocate
    result = Categories::AllocateAmount.new(params: params).perform
    rendur result
  end
end
