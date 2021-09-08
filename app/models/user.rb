class User < ApplicationRecord
    has_many :comments
    has_many :pins

    #refer to it as pinlist, but is an Pin model
    has_and_belongs_to_many :pinlist, class_name: 'Pin'
end
