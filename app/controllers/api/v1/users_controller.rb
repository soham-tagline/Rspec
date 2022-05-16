# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.all

        @pagy, @records = pagy(@users)
        serialized_users = UserSerializer.new(@records).serializable_hash

        render_jsonapi(serialized_users)
      end

      def show
        render_jsonapi(UserSerializer.new(@user).serializable_hash)
      end

      def create
        @user = User.new(user_params)

        if @user.save
          render_jsonapi(UserSerializer.new(@user).serializable_hash, status: :created)
        else
          render_jsonapi({ errors: @user.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      def update
        if @user.update(user_params)
          render_jsonapi(UserSerializer.new(@user).serializable_hash, status: :ok)
        else
          render_jsonapi({ errors: @user.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      def destroy
        if @user.destroy
          render_jsonapi(UserSerializer.new(@user).serializable_hash, status: :ok)
        else
          render_jsonapi({ errors: @user.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :password, :headline, :dob)
      end
    end
  end
end
