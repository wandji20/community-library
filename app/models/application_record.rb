class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def record_url(name)
    return unless self.try(name).try(:attached?)

    url = if Rails.env.development?
      Rails.application.routes.url_helpers.rails_blob_url(self.try(name))
    else
      self.try(name).try(:url)
    end
    url
  end
end
