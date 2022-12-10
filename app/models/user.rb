class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :trip_users, dependent: :destroy
  has_many :trips, through: :trip_users

  validates :nickname, presence: true

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'should be half-width only, including both letters and numbers',
                      on: :create
  # trip_usersテーブルの作成の際にバリデーションをかけてしまうため、on: :createを設定し、ユーザー登録時のみに設定。
end
