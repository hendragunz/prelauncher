module Concerns::User::Authentication
  extend ActiveSupport::Concern
  module ClassMethods
    def process_uri(uri)
      photo_url = URI.parse(uri)
      photo_url.scheme = 'https'
      photo_url.to_s
    end

    # create or find the auth for social networking
    def find_or_create(auth)
      user = User.joins(:social_networks)
                 .where("social_networks.provider = ?", auth.provider)
                 .where("social_networks.uid = ?", auth.uid)
                 .first

      unless user
        user = User.new(email: auth.info.email,
                        username: auth.raw_info.try(:username) || auth.info.email.split('@').first,
                        password: Devise.friendly_token[0,20])
                        # remote_avatar_url: auth.info.image.present? ? process_uri(auth.info.image.sub("square","large")) : "")



        user.social_networks.build(
          provider:     auth.provider,
          token:        auth.credentials.token,
          uid:          auth.uid,
          raw_info:     auth.to_hash
        )

        user.skip_confirmation!
        if user.save
          user.attributes = {
            gender:       auth.extra.raw_info.gender.present? ? auth.extra.raw_info.gender : "",
            full_name:    auth.info.name,
            introduction: auth.extra.raw_info.bio.present? ? auth.extra.raw_info.bio : ""
          }
          user.save
        end
      end

      # return user
      user
    end
  end
end
