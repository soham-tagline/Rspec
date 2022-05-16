# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include Pagy::Backend

      private

      def render_jsonapi(object, **options)
        render(json: object, **options)
      end
    end
  end
end
