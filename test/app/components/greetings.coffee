window.db = greetings: {}

Greetings =
  get: ({ key }) -> Promise.resolve window.db.greetings[key]
  put: ({ key, name, salutation }) ->
    Promise.resolve window.db.greetings[key] = { name, salutation }

export default Greetings
