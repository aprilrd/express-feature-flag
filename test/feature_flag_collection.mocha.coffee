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
    it 'generates a FeatureFlagCollection instance without arguments', ->
      featureFlagCollection = new FeatureFlagCollection()
      expect(featureFlagCollection).to.have.property('flags').that.deep.equals({})

    it 'generates a FeatureFlagCollection instance with empty object', ->
      featureFlagCollection = new FeatureFlagCollection({})
      expect(featureFlagCollection).to.have.property('flags').that.deep.equals({})

    it 'generates a FeatureFlagCollection instance with the given flag object', ->
      featureFlagCollection = new FeatureFlagCollection({ flags: { a: true } })
      expect(featureFlagCollection).to.have.property('flags').that.deep.equals({
        a: true
      })

  describe '#get', ->
    featureFlagCollection = null

    before ->
      featureFlagCollection = new FeatureFlagCollection({
        flags: {
          a: true
          b: false
        }
      })

    it 'returns true for the enabled feature', ->
      expect(featureFlagCollection.get('a')).to.be.true

    it 'returns false for the disabled feature', ->
      expect(featureFlagCollection.get('b')).to.be.false

    it 'returns false for the undefined feature', ->
      expect(featureFlagCollection.get('c')).to.be.false
