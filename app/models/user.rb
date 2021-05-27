class User < ApplicationRecord
  before_save :name_beautifier

  enum role: %i[normal reviewer]
  enum language: %i[ruby php java frontend android ios testing python]

  store_accessor :settings, :last_states, :last_rooms, :last_repositories, :last_languages

  belongs_to :room, optional: true
  has_many :pull_requests, dependent: :destroy

  validate :room_vaild, on: :update
  validates :language, presence: true, on: :update

  scope :select_merged, (lambda do
    select :id, :name, :login, :merged, :room_id
  end)

  scope :merged_great_than, (lambda do |number_param|
    where arel_table[:merged].gt number_param
  end)

  delegate :name, to: :room, prefix: true, allow_nil: true

  def name
    super || "@#{login}"
  end

  def avatar
    super || "avatar_notfound.png"
  end

  def last_states
    super || [1, 2]
  end

  def last_rooms
    super || [room_id]
  end

  def last_repositories
    super.to_a
  end

  def last_languages
    super.to_a
  end

  def to_cw
    "[To:#{chatwork}] #{name}"
  end

  def to_cc
    "[CC]#{to_cw}"
  end

  def to_picon
    return name unless chatwork?
    "[piconname:#{chatwork}]"
  end

  def warning?
    !(chatwork? && room_id?)
  end

  private

  def name_beautifier
    return if name.blank?
    self.name = name.split("\u0028").first.try :strip
  end

  def room_vaild
    return if room_id.nil? || Room.exists?(room_id)
    errors.add :room_id, :invalid
  end
end
