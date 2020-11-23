class Person < ApplicationRecord
  validates_presence_of :first_name, :last_name, :email, :age
  has_paper_trail :on => [:update, :destroy]
end
