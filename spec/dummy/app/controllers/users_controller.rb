class UsersController < ApplicationController
  def index
    @users = User.all.to_a
    some_proc = proc { 1 + 1 }
    render json: @users
    binding.dump do |data|
      StoredBinding.create(data: data.force_encoding('utf-8'))
    end
    binding.pry
  end
end
