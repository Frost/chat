mongoose = require "mongoose"
Schema   = mongoose.Schema

# For supporting { type: [String], enum: [...] } validation
mongoose.plugin (schema, options) ->
  # Internal holder for enums per path
  enumPath = {}

  # Internal validator
  validator = (array) ->
    for string in array
      return false if string not in @
    return true

  # Check this schemas paths for { type: [String], enum: [...] }
  schema.eachPath (path) ->
    type = schema.path path
    if type.options.type[0]?.name is "String" and type.options.enum?
      enumPath[path] = type.options.enum
      boundValidator = validator.bind type.options.enum
      type.validate boundValidator, "enum"

  # Method to get enum for a path or "undefined" otherwise
  schema.methods.enum = (path) -> enumPath[path]

module.exports = Schema