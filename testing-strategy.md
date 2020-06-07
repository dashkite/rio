# Testing Carbon 3

Testing Carbon's combinators is tricky. Many combinators depend on others. For example, we can’t test `matches` without also testing `event`. We can’t easily test them in isolation either, since many depend on the existence of a Web Component attached to the DOM. For example, `event` needs a DOM node to which to attach the event listener.

A functional approach, focused on common scenarios might work best. After all, we’ve done enough work with Web Components to be familiar with a variety of scenarios. We know of three basic scenarios: view, create, and update.