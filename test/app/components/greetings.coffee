window.db = greetings: {}

Greetings =
  get: (key) -> Promise.resolve window.db.greetings[key]
  put: (key, data) -> Promise.resolve window.db.greetings[key] = data

export default Greetings
