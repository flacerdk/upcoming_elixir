# Upcoming

This is work-in-progress. When finished it'll implement a tool for making Spotify playlists from upcoming concerts in a city. The idea comes from [this blog post](https://kyleconroy.com/upcoming).

Right now there are some functions for fetching the venues for a location and fetch upcoming events given a venue. What's missing is integrating the Spotify API so we can start making playlists based on the events.


## Setup

Create a `config/config.secret.exs` with the following contents:

```elixir
use Mix.Config

config :upcoming_elixir,
  api_key: <YOUR_SONGKICK_API_KEY>
```

Replace <YOUR_SONGKICK_API_KEY> with your Songkick API key. [Apply for a key](https://www.songkick.com/api_key_requests/new) if you don't have one.
