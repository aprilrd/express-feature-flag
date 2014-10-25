'use strict'

FeatureFlagCollection = require './feature_flag_collection'

module.exports = ->
  throw new Error("one argument is needed") unless arguments[0]
  { ruleGenerator, contextGenerator } = arguments[0]
  throw new Error("ruleGenerator needs to be supplied") if not ruleGenerator

  contextGenerator or= (req, callback) ->
    callback(null, req)
    return

  return (req, res, next) ->
    ruleGenerator (err, rules) ->
      if err
        rules = {}

      contextGenerator(req, (err, context) ->
        if err
          next(err)
          return

        req._featureFlags = FeatureFlagCollection.generate({
          rules
          context
        })
        next()
      )
      return
    return
