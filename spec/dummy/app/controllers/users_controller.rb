class UsersController < ApplicationController
  def index
    ActiveRecord::Base.logger = Logger.new('/dev/null')
    @users = User.all.to_a
    some_proc = proc { 1 + 1 }
    t = Time.now
    binding.dump do |data|
      StoredBinding.create(data: data.force_encoding('utf-8'))
    end
    Rails.logger.info(Time.now - t)
    render json: @users
  end
end
