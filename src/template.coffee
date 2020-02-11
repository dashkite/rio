import {curry} from "panda-garden"
import {isArray, isString, isObject,
  isDefined, isUndefined} from "panda-parchment"
import Generic from "panda-generics"

normalize = Generic.create name: "normalize"

Generic.define normalize, isUndefined, isObject, (value, context) ->

Generic.define normalize, isDefined, isObject, (value, context) ->
  context[k] = v for k, v of value when v?

Generic.define normalize, isString, isObject, (value, context) ->
  context.value = value

Generic.define normalize, isArray, isObject, (value, context) ->
  context.results = value

# Adapt a template so that it can merge together component facets
smart = curry (template, object) ->

  # facets
  {description, value, view} = object

  # if we don't have a value, do nothing
  # TODO add a loader here?
  if value?

    # build up composite from facets
    r = {}

    # lowest precedence is description
    r[k] = v for k, v of description if description?

    normalize value, r

    # view has the highest precedence
    # view may be async
    _view = await view
    # don't overwrite with null properties
    r[k] = v for k, v of _view when v? if _view?

    # invoke template using composite
    template r


# Adapt a template so that it can merge together component facets
determined = curry (template, object) ->

  # facets
  {description, value, view} = object

  # build up composite from facets
  r = {}

  # lowest precedence is description
  r[k] = v for k, v of description if description?

  normalize value, r

  # view has the highest precedence
  # view may be async
  _view = await view
  # don't overwrite with null properties
  r[k] = v for k, v of _view when v? if _view?

  # invoke template using composite
  template r

export {smart, determined}
