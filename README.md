# express-feature-flag

Feature Flag system as an [express.js]( https://github.com/visionmedia/express ) middleware.

## Installation

```
npm install express-feature-flag
```

## Usage

```javascript
app.use(require('express-feature-flag')({
  contextGenerator: function (req, callback) {
    callback(null, req.session); //do other queries if necessary
    return;
  },

  ruleGenerator: function (callback) {
    queryFeatureFlagDB(function (err, featureFlagRules) {
      if (err) {
        callback(err);
        return;
      }

      var rule, rules, _i, _len;

      rules = {};

      for (_i = 0, _len = featureFlagRules.length; _i < _len; _i++) {
        rule = featureFlagRules[_i];
        rules[rule.name] = parseRuleSpec(rule.rule);
      }

      callback(null, {
        rules: rules
      });
    })
  }
})); // returns a middleware function
```

###Middleware Options
####`contextGenerator` Function(req, callback) [_optional_]
An asynchronous function to generate `context` which will then be used as an argument to feature flag rules.

If not supplied, `context` will be `req`.

####`ruleGenerator` Function(callback) [_required_]
An asynchronous function to generate rules.

callback's first argument is `error` and second argument is `rules`. `rules` have to be an object whose names are the name of rules and values are functions that takes `context` and returns `boolean`.

`rules` Example:
```javascript
{
  htmlEmail: function (context) {
    if (context.type === 'admin') {
        return true;
    }
    return false;
  }
}
```
## ToDo
- Include basic rule spec

## Changelog

### v0.1.3
- Added stricter type checking to FeatureFlagCollection

### v0.1.0
- Initial release

## Contributors

- Young Kim <aprilrd8943@gmail.com>

## License
ISC License
