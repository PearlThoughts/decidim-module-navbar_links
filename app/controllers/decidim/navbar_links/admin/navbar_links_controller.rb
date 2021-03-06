# frozen_string_literal: true

module Decidim
  module NavbarLinks
    module Admin
      class NavbarLinksController < NavbarLinks::Admin::ApplicationController
        layout "decidim/admin/settings"
        helper_method :navbar_link

        def index
          enforce_permission_to :index, :navbar_link
          @navbar_links = NavbarLink.organization(current_organization)
        end

        def new
          enforce_permission_to :new, :navbar_link
          @form = form(Decidim::NavbarLinks::Admin::NavbarLinkForm).instance
        end

        def create
          enforce_permission_to :new, :navbar_link
          @form = form(Decidim::NavbarLinks::Admin::NavbarLinkForm).from_params(params)

          Decidim::NavbarLinks::Admin::CreateNavbarLink.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("navbar_links.create.success", scope: "decidim.admin")
              redirect_to navbar_links_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("navbar_links.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :navbar_link, navbar_link: navbar_link
          @form = form(Decidim::NavbarLinks::Admin::NavbarLinkForm).from_model(navbar_link)
        end

        def update
          enforce_permission_to :update, :navbar_link, navbar_link: navbar_link
          @form = form(Decidim::NavbarLinks::Admin::NavbarLinkForm).from_params(params)

          Decidim::NavbarLinks::Admin::UpdateNavbarLink.call(@form, navbar_link) do
            on(:ok) do
              flash[:notice] = I18n.t("navbar_links.update.success", scope: "decidim.admin")
              redirect_to navbar_links_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("navbar_links.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :navbar_link
          navbar_link.destroy!

          flash[:notice] = I18n.t("navbar_links.destroy.success", scope: "decidim.admin")

          redirect_to navbar_links_path
        end

        private

        def navbar_link
          @navbar_link = Decidim::NavbarLinks::NavbarLink.find(params[:id])
        end
      end
    end
  end
end
