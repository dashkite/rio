import { call } from "./call"

# TODO make this configurable
Codes =
  valueMissing: "Please provide a value for this field"
  typeMismatch: "Please provide a valid email"

Element =

  configure: ( element ) ->
    for code, value in element.validity
      if value && Codes[ code ]?
        element.setCustomValidity Codes[ code ]

  validate: ( element ) ->
    element.setCustomValidity ""
    if do element.checkValidity
      true
    else
      Element.configure element
      do element.reportValidity
      false

Form =

  validate: ( form ) ->
    Array
      .from form.elements
      .every Element.validate

validate = call ->
  forms = Array.from @root.querySelectorAll "form"
  if ( forms.every Form.validate )
    @dispatch "valid"
    true
  else
    # TODO the form elements already dispatch invalid events
    # we want the component itself to do so in this case
    # but wouldn't the element events bubble up?
    @dispatch "invalid"
    false  

export { validate }