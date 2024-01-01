import { call } from "./call"

validate = call ->
  forms = @root.querySelectorAll "form"
  for form in forms
    inputs = form.elements
    for input in inputs
      input.setCustomValidity('')
      unless input.checkValidity()
        if input.validity.valueMissing
          input.setCustomValidity("this field is missing a value!")
        else if input.validity.typeMismatch
          if input.type == "email"
            input.setCustomValidity("please provide a valid email") 
        input.reportValidity()
        @.dispatch "invalid"
        return false
  @.dispatch "valid"
  true

export { validate }