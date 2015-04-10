# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  referral_code          :string(255)
#  referrer_id            :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  gender                 :string(255)
#  full_name              :string(255)
#  introduction           :text
#  referrals_count        :integer          default(0), not null
#

class User < ActiveRecord::Base
  include Concerns::User::Authentication

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :validatable, :database_authenticatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  belongs_to  :referrer,        class_name: "User", foreign_key: "referrer_id"
  has_many    :referrals,       class_name: "User", foreign_key: "referrer_id"
  has_many    :social_networks, dependent: :destroy

  counter_culture :referrer, column_name: 'referrals_count'

  # validations
  validates :referral_code, :uniqueness => true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
      {
          'count' => 5,
          "html" => "Shave<br>Cream",
          "class" => "two",
          "image" =>  ActionController::Base.helpers.asset_path("refer/cream-tooltip@2x.png")
      },
      {
          'count' => 10,
          "html" => "Truman Handle<br>w/ Blade",
          "class" => "three",
          "image" => ActionController::Base.helpers.asset_path("refer/truman@2x.png")
      },
      {
          'count' => 25,
          "html" => "Winston<br>Shave Set",
          "class" => "four",
          "image" => ActionController::Base.helpers.asset_path("refer/winston@2x.png")
      },
      {
          'count' => 50,
          "html" => "One Year<br>Free Blades",
          "class" => "five",
          "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
      }
  ]

  private

  def create_referral_code
      referral_code = SecureRandom.hex(5)
      @collision = User.find_by_referral_code(referral_code)

      while !@collision.nil?
          referral_code = SecureRandom.hex(5)
          @collision = User.find_by_referral_code(referral_code)
      end

      self.referral_code = referral_code
  end

  def send_welcome_email
      UserMailer.delay.signup_email(self)
  end
end
