_ = require 'lodash'
{ isInstanceOf } = require 'higher-object/build/index'

class FeatureFlagCollection
  @generate: ({rules, context}) ->
    flags = {}

    for k, v of rules
      flags[k] = v(context)

    return new FeatureFlagCollection({flags})

  @isFeatureFlagCollection: (candidate) ->
    return isInstanceOf(candidate, FeatureFlagCollection)

  @fromJS: ({flags}) ->
    return new FeatureFlagCollection({flags})

  constructor: (args) ->
    @flags = args?.flags ? {}
    throw new Error('flags should be an object') if typeof @flags isnt 'object'

  valueOf: ->
    return {
      @flags
    }

  toJS: ->
    return @valueOf()

  toJSON: ->
    return @toJS()

  toString: ->
    return '[FeatureFlagCollection]'

  equals: (candidate) ->
    return false unless FeatureFlagCollection.isFeatureFlagCollection(candidate)
    return _.isEqual(candidate.flags, @flags)

  get: (name) ->
    return @flags[name] ? false

module.exports = FeatureFlagCollection
