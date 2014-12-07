_ = require 'lodash'
{ isInstanceOf } = require 'higher-object/build/index'

class FeatureFlagCollection
  @isFeatureFlagCollection: (candidate) ->
    return isInstanceOf(candidate, FeatureFlagCollection)

  @fromJS: ({rules, context}) ->
    return new FeatureFlagCollection({rules, context})

  constructor: (args) ->
    throw new Error('needs rules and context') if not args
    {@rules, @context} = args
    throw new Error('needs rules') if not @rules
    throw new Error('rules should be an object') if typeof @rules isnt 'object'
    for ruleName, rule of @rules
      throw new Error("rule #{ruleName} should be a function") if typeof rule isnt 'function'

    throw new Error('needs context') if not @context
    throw new Error('context should be an object') if typeof @context isnt 'object'

    @_cache = {}

  valueOf: ->
    return {
      @rules
      @context
    }

  toJS: ->
    return @valueOf()

  toJSON: ->
    return {
      @rules
      @context
    }

  toString: ->
    return '[FeatureFlagCollection]'

  equals: (candidate) ->
    return false unless FeatureFlagCollection.isFeatureFlagCollection(candidate)
    return false unless _.isEqual(Object.keys(candidate.rules), Object.keys(@rules))
    for ruleName, rule of candidate.rules
      return false if candidate.get(ruleName) isnt @get(ruleName)
    return true

  get: (name) ->
    return @_cache[name] if @_cache[name]?
    if not @rules[name]
      return false
    else
      return @_cache[name] = @rules[name](@context)

  getAll: ->
    for k, v of @rules
      @_cache[k] = v(@context) if not @_cache[k]?

    result = {}
    result[k] = v for k, v of @_cache
    return result

  setContext: (context) ->
    @context = context
    @_cache = {}
    return true

  getContext: -> return @context


module.exports = FeatureFlagCollection
