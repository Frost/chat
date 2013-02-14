mongoose = require "mongoose"
Schema   = require "./Schema"

UserSchema = new Schema
  name: 
    type: String
    trim: true
    unique: true
    required: true

exports.Schema = UserSchema
exports.Model  = mongoose.model "User", UserSchema