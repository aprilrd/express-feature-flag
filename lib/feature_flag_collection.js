// Generated by CoffeeScript 1.8.0
var FeatureFlagCollection, isInstanceOf, _;

_ = require('lodash');

isInstanceOf = require('higher-object/build/index').isInstanceOf;

FeatureFlagCollection = (function() {
  FeatureFlagCollection.generate = function(_arg) {
    var context, flags, k, rules, v;
    rules = _arg.rules, context = _arg.context;
    flags = {};
    for (k in rules) {
      v = rules[k];
      flags[k] = v(context);
    }
    return new FeatureFlagCollection({
      flags: flags
    });
  };

  FeatureFlagCollection.isFeatureFlagCollection = function(candidate) {
    return isInstanceOf(candidate, FeatureFlagCollection);
  };

  FeatureFlagCollection.fromJS = function(_arg) {
    var flags;
    flags = _arg.flags;
    return new FeatureFlagCollection({
      flags: flags
    });
  };

  function FeatureFlagCollection(args) {
    var _ref;
    this.flags = (_ref = args != null ? args.flags : void 0) != null ? _ref : {};
    if (typeof this.flags !== 'object') {
      throw new Error('flags should be an object');
    }
  }

  FeatureFlagCollection.prototype.valueOf = function() {
    return {
      flags: this.flags
    };
  };

  FeatureFlagCollection.prototype.toJS = function() {
    return this.valueOf();
  };

  FeatureFlagCollection.prototype.toJSON = function() {
    return this.toJS();
  };

  FeatureFlagCollection.prototype.toString = function() {
    return '[FeatureFlagCollection]';
  };

  FeatureFlagCollection.prototype.equals = function(candidate) {
    if (!FeatureFlagCollection.isFeatureFlagCollection(candidate)) {
      return false;
    }
    return _.isEqual(candidate.flags, this.flags);
  };

  FeatureFlagCollection.prototype.get = function(name) {
    var _ref;
    return (_ref = this.flags[name]) != null ? _ref : false;
  };

  return FeatureFlagCollection;

})();

module.exports = FeatureFlagCollection;