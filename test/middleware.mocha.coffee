{ expect } = require 'chai'
express = require 'express'
request = require 'supertest'

FeatureFlag = require '../src/middleware'

describe 'FeatureFlag middleware', ->
  app = null
  session = null

  describe 'one rule', ->
    before ->
      app = express()
      app.use((req, res, next) ->
        req.session = session
        next()
      )
      app.use(FeatureFlag {
        ruleGenerator: (callback) ->
          rules = {
            test: (context) ->
              return context.email is 'test@test.com'
          }
          callback(null, rules)
          return

        contextGenerator: (req, callback) ->
          callback(null, req.session)
          return
      } )
      app.get('/', (req, res) ->
        res.status(200).json(req._featureFlags)
      )

    it 'correctly gets false flag for req._featureFlags', (done) ->
      session = {
        email: 'blh'
      }
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) ->
          expect(err).not.to.exist
          expect(res.body.flags).to.have.property('test', false)
          done()
        )

    it 'correctly gets true flag for req._featureFlags', (done) ->
      session = {
        email: 'test@test.com'
      }
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) ->
          expect(err).not.to.exist
          expect(res.body.flags).to.have.property('test', true)
          done()
        )

  describe 'percentage rule', ->
    before ->
      app = express()
      app.use((req, res, next) ->
        req.session = session
        next()
      )
      app.use(FeatureFlag {
        ruleGenerator: (callback) ->
          rules = {
            percentage: (context) ->
              return false unless context.email
              hash = 0
              for char, i in context.email
                hash = (hash * 31 - hash) + context.email.charCodeAt(i)

              return (hash % 100) < 30
          }
          callback(null, rules)
          return

        contextGenerator: (req, callback) ->
          callback(null, req.session)
          return
      } )
      app.get('/', (req, res) ->
        res.status(200).json(req._featureFlags)
      )

    it 'correctly gets false flag for req._featureFlags', (done) ->
      session = {
        email: 'blh'
      }
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) ->
          expect(err).not.to.exist
          expect(res.body.flags).to.have.property('percentage', false)
          done()
        )

    it 'correctly gets true flag for req._featureFlags', (done) ->
      session = {
        email: 'test@test.com'
      }
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) ->
          expect(err).not.to.exist
          expect(res.body.flags).to.have.property('percentage', true)
          done()
        )
