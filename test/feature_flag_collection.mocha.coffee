{ expect } = require 'chai'

FeatureFlagCollection = require '../src/feature_flag_collection'

HigherObjectTesterModule = require("higher-object/build/tester.js")
testHigherObjects = HigherObjectTesterModule.testHigherObjects

testFeatureFlagCollections = [
  {
    rules: {
      check: -> return true
    }
    context: {}
  }
  {
    rules: {
      check: -> return false
    }
    context: {}
  }
]

describe 'FeatureFlagCollections', ->
  it 'passes higher object tests', ->
    testHigherObjects(FeatureFlagCollection, testFeatureFlagCollections)

  # describe 'generate', ->
  #   it 'properly generates a FeatureFlagCollection instance', ->
  #     featureFlagCollection = FeatureFlagCollection.generate {
  #       context: {
  #         test: true
  #       }
  #       rules: {
  #         check: -> return true
  #       }
  #     }
  #     expect(featureFlagCollection).to.have.deep.property('flags.check', true)

  #   it 'fails with a function that does not return boolean', ->
  #     expect(->
  #       FeatureFlagCollection.generate {
  #         context: {
  #           test: true
  #         }
  #         rules: {
  #           check: -> return 1
  #         }
  #       }
  #     ).to.throw("rule 'check' returned non-boolean")

  describe '#constructor', ->
    it 'throws an error without arguments', ->
      expect(->
        featureFlagCollection = new FeatureFlagCollection()
      ).to.throw('needs rules and context')

    it 'throws an error with empty object', ->
      expect(->
        featureFlagCollection = new FeatureFlagCollection({})
      ).to.throw('needs rules')

    it 'generates a FeatureFlagCollection instance with the given flag object', ->
      featureFlagCollection = new FeatureFlagCollection({
        context: {
          test: true
        }
        rules: {
          check: -> return 1
          test: (context) -> return context.test
        }
      })
      expect(featureFlagCollection.get('check')).to.equal(1)
      expect(featureFlagCollection.get('test')).to.be.equal


  describe '#get', ->
    featureFlagCollection = null

    beforeEach ->
      featureFlagCollection = new FeatureFlagCollection({
        context: {
          test: true
        }
        rules: {
          a: (context) -> return context.test
        }
      })

    it 'returns true for the enabled feature', ->
      expect(featureFlagCollection.get('a')).to.be.true

    it 'returns false for the disabled feature', ->
      expect(featureFlagCollection.get('b')).to.be.false

    it 'returns false for the undefined feature', ->
      expect(featureFlagCollection.get('c')).to.be.false

    it 'does lazy evaluation', ->
      expect(featureFlagCollection.get('a')).to.be.true
      featureFlagCollection.setContext({ test: false })
      expect(featureFlagCollection.get('a')).to.be.false

