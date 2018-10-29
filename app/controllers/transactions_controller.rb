# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    result = Debits::Create.new(params: params).perform
    rendur result
  end

  def show
    result = Debits::Fetch.new(params: params).perform
    rendur result
  end

  def index
    result = Debits::List.new(params: params).perform
    rendur result
  end

  def update
    result = Debits::Update.new(params: params).perform
    rendur result
  end

  def destroy
    result = Debits::Destroy.new(params: params).perform
    rendur result
  end
end
