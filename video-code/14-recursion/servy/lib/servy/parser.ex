defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines, %{})

    params = parse_params(headers["Content-Type"], params_string)

    IO.inspect header_lines

    %Conv{
       method: method,
       path: path,
       params: params,
       headers: headers
     }
  end

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
    IO.puts(headers)
  end

  def parse_headers([], headers), do: headers

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  defmodule Recurse do

    def sum([head | tail], total) do
      IO.puts "Head: #{head} Tail: #{inspect(tail)}"
      total = total + head
      sum(tail, total)
    end

    def sum([]), do: IO.puts "Done!"
  end

end
