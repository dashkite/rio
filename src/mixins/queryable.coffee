import {prepare} from "./phased"

queryable = prepare ->

  @query =

    element: new Proxy @,
      get: (target, selector) ->
        target.root.querySelector selector

    elements: new Proxy @,
      get: (target, selector) ->
        target.root.querySelectorAll selector

    form: new Proxy @,
      get: (target, name) ->
        target.query.element["[name='#{name}']"]?.value

export {queryable}
