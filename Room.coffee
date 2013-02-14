mongoose = require "mongoose"
Schema   = require "./Schema"

MessageSchema = new Schema
  at: Date
  user:
   type: Schema.Types.ObjectId
   ref: "User"
  text: String

RoomSchema = new Schema
  owner:
   type: Schema.Types.ObjectId
   ref: "User"
  private:
    type: Boolean
    default: false
  name: 
    type: String
    trim: true
    unique: true
    required: true
  messages: [MessageSchema]

exports.Schema = RoomSchema
exports.Model  = mongoose.model "Room", RoomSchema