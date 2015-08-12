class UsersController < ApplicationController
  def index
    @users = User.all
    some_proc = proc { 1 + 1 }
    binding.dump do |data|
      binding.pry
      StoredBinding.create(data: data)
    end
    render json: @users
  end
end
