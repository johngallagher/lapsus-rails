class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects
  has_many :entries
  has_many :containers

  after_create :create_none_project

  def possible_container_paths
    entries.possible_paths - containers.path_heirarchies
  end

  def none_project
    Project.none_for_user(self)
  end

  def create_entry(attrs)
    attrs[:project_id] = none_project.id if attrs[:project_id].nil?
    self.entries.create(attrs)
  end

  def new_entry(attrs)
    attrs[:project_id] = none_project.id if attrs[:project_id].nil?
    self.entries.build(attrs)
  end

  private
  def create_none_project
    Project.create_none_for_user!(self)
  end
end
