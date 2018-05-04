defmodule Chatboot.Bot do
  use ChatbootWeb, :controller
  alias Chatboot.Podcast

  def whitelist_urls do
    body =
      %{
        setting_type: "domain_whitelisting",
        whitelisted_domains: [
          Application.get_env(:chatboot, :bot)[:host],
          "https://panoptikum.io/"
        ],
        domain_action_type: "add"
      }
      |> Poison.encode!()

    facebook_request_url("thread_settings", access_token_params())
    |> HTTPoison.post(body, ["Content-Type": "application/json"], stream_to: self())
  end

  defp facebook_request_url(path, params) do
    "https://graph.facebook.com/v2.6/me/#{path}?#{params}"
  end

  defp access_token_params do
    %{
      access_token: Application.get_env(:chatboot, :bot)[:fb_access_token]
    }
    |> URI.encode_query()
  end

  def respond_to_message(message, sender_id) do
    data =
      %{
        recipient: %{
          id: sender_id
        },
        message: message_response(podcasts_from_query(message))
      }
      |> Poison.encode!()

    facebook_request_url("messages", access_token_params())
    |> HTTPoison.post(data, ["Content-Type": "application/json"], stream_to: self())
  end

  defp podcasts_from_query(message) do
    query = [
      index: "/panoptikum_" <> Application.get_env(:chatboot, :environment),
      search: [
        size: 5,
        from: 0,
        query: [
          function_score: [
            query: [match: [_all: [query: message]]],
            boost_mode: "multiply",
            functions: [
              %{filter: [term: [_type: "categories"]], weight: 0},
              %{filter: [term: [_type: "podcasts"]], weight: 1},
              %{filter: [term: [_type: "personas"]], weight: 0},
              %{filter: [term: [_type: "episodes"]], weight: 0},
              %{filter: [term: [_type: "users"]], weight: 0}
            ]
          ]
        ]
      ]
    ]

    {:ok, 200, %{hits: hits, took: _took}} = Tirexs.Query.create_resource(query)

    podcast_ids = Enum.map(hits.hits, fn hit -> hit._id end)

    from(p in Podcast, where: p.id in ^podcast_ids, preload: :episodes)
    |> Chatboot.Repo.all()
  end

  defp message_response([]) do
    %{
      text: "Sorry! I couldn't find any podcasts with that. How about \"Serial\"?"
    }
  end

  defp message_response(podcasts) do
    %{
      attachment: %{
        type: "template",
        payload: %{
          template_type: "generic",
          elements: Enum.map(podcasts, &podcast_json(&1))
        }
      }
    }
  end
end
