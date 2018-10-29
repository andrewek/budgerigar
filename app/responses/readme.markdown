# Response Objects

These are pretty simple ruby objects whose sole purpose is to encapsulate the
result of an `Operation`. This makes it easier for operations to be composed
with a given operation needing to know how any other operation defines success.

Initialize like so:

```ruby
# From inside an operation
response = Success.new(record, self)
```

You can serialize like so:

```ruby
some_hash = response.serialize
```

You can check for general success:

```ruby
response.success?
# => true

response.failure?
# => false
```

You can grab the corresponding HTTP status code (human-readable):

```ruby
response.status
# => :ok
```

Finally, you can grab the response's originating operation (in case you need to
roll back the operation itself, in case of failure in a multi-step process).

```ruby
response.source
# => SomeOperation
```
