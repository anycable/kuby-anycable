[![Gem Version](https://badge.fury.io/rb/kuby-anycable.svg)](https://rubygems.org/gems/kuby-anycable)

# Kuby AnyCable

[Kuby][] plugin to deploy [AnyCable][] applications.

This plugin allows you to install all the required AnyCable components to a Kubernetes cluster.

## Installation

Add to your project:

```ruby
# Gemfile
gem "kuby-anycable"
```

## Usage

Here is the minimal configuration:

```ruby
# kuby.rb

require "kuby-anycable"

# ...

Kuby.define("my-app") do
  environment(:production) do
    #...

    kubernetes do
      add_plugin :rails_app do
        # ...
      end

      add_plugin :anycable_rpc
      add_plugin :anycable_go
    end
  end
end
```

What happens under the hood:

- RPC service definitions are created:
  - The current `rails_app` image is used for the container.
  - The `rails_app` Config Map is attached to the RPC container.
- AnyCable-Go service definitions are created:
  - The latest stable image is used for `anycable-go`.
  - Connected to the RPC service (using [DNS load balancing](https://docs.anycable.io/deployment/load_balancing?id=client-side-load-balancing) by default).
  - Redis URL is inferred from the RPC service `ANYCABLE_REDIS_URL` or `REDIS_URL`.
  - [Concurrency settings](https://docs.anycable.io/anycable-go/configuration?id=concurrency-settings) are adjusted according to the number of RPC servers and their concurrency settings.

Of course, you can customize the resources:

```ruby
add_plugin :anycable_rpc do
  replicas 2
  # Provide Redis URL explicitly.
  redis_url "redis://custom_url"
  # Override gRPC server port (but why?)
  port 50051
  # Expose additional port named 'metrics'
  # (e.g., if you use Prometheus exporter).
  # Disabled by default.
  metrics_port 3030
  # Shortcut for ENV['ANYCABLE_RPC_SERVER_ARGS__MAX_CONNECTION_AGE_MS']
  max_connection_age 300000
  # Shortcut for ENV['ANYCABLE_RPC_POOL_SIZE']
  rpc_pool_size 30
end

add_plugin :anycable_go do
  replicas 2
  # Provide Redis URL explicitly.
  redis_url "redis://custom_url"
  # Override web server port (but why?)
  port 8081
  # Metrics port (enabled by default and exposed as "metrics")
  metric_port 5001
  # Provide path to RPC server explicitly
  rpc_host "my-app-rpc:50051"
  # WebSocket endpoint path
  ws_path "/cable"
  # AnyCable-Go Dockerimage
  image "anycable/anycable-go:1.1"
  # Specify ENV['ANYCABLE_RPC_CONCURRENCY'] explicitly
  rpc_concurrency nil
  # Use a separate hostname for AnyCable-Go
  # (disabled by default)
  hostname nil
end
```

### Using with Alpine images

Installing Ruby deps on Apline images requires some special attention to gRPC-related gems (tl;dl we need to build them from source).

Kuby AnyCable comes with a special _package_, which installs everything for you (so you shouldn't use any hacks yourself). You need to add a single line:

```ruby
Kuby.define("my-app") do
  environment(:production) do
    docker do
      # ...
      distro :apline
      package_phase.add("anycable-build")

      # ...
    end

    # ...
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/palkan/kuby-anycable](https://github.com/palkan/kuby-anycable).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[Kuby]: https://getkuby.io
[AnyCable]: https://anycable.io
