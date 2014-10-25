{ expect } = require 'chai'

FeatureFlagCollection = require '../src/feature_flag_collection'

HigherObjectTesterModule = require("higher-object/build/tester.js")
testHigherObjects = HigherObjectTesterModule.testHigherObjects

testFeatureFlagCollections = [
  {
    flags: {
      a: true
      b: false
      c: false
    }
  }
  {
    flags: {
      a: true
      b: false
    }
  }
]

describe 'FeatureFlagCollections', ->
  it 'passes higher object tests', ->
    testHigherObjects(FeatureFlagCollection, testFeatureFlagCollections)

  describe 'generate', ->
    it 'properly generates a FeatureFlagCollection instance', ->
      featureFlagCollection = FeatureFlagCollection.generate {
        context: {
          test: true
        }
        rules: {
          check: -> return true
        }
      }
      expect(featureFlagCollection).to.have.deep.property('flags.check', true)

  describe '#constructor', ->
    it 'properly generates a FeatureFlagCollection instance', ->
      featureFlagCollection = new FeatureFlagCollection()


  describe '#get', ->


