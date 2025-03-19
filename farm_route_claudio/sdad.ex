defmodule FarmRouteOptimizer do
  @moduledoc """
  Sistema para otimização de rotas entre fazendas baseado em suas localizações geográficas.
  Utiliza o algoritmo do vizinho mais próximo para calcular um caminho eficiente.
  """

  @doc """
  Inicia a aplicação principal
  """
  def main do
    IO.puts("\n=== OTIMIZADOR DE ROTAS PARA FAZENDAS ===\n")
    IO.puts("Digite as localizações das fazendas (latitude,longitude).")
    IO.puts("Digite 'calcular' quando terminar de adicionar todas as fazendas.\n")

    process_input([])
  end

  @doc """
  Processa a entrada do usuário recursivamente
  """
  def process_input(farms) do
    IO.write("Fazenda #{length(farms) + 1} (ou 'calcular'): ")
    input = IO.gets("") |> String.trim()

    cond do
      input == "calcular" ->
        if length(farms) < 2 do
          IO.puts("\nPor favor, adicione pelo menos 2 fazendas para calcular uma rota.")
          process_input(farms)
        else
          calculate_route(farms)
        end

      true ->
        case parse_coordinates(input) do
          {:ok, coordinates} ->
            farm = %{id: length(farms) + 1, coordinates: coordinates}
            IO.puts("Fazenda #{farm.id} adicionada: #{format_coordinates(coordinates)}")
            process_input(farms ++ [farm])

          :error ->
            IO.puts("Formato inválido. Use 'latitude,longitude' (ex: -23.5505,-46.6333)")
            process_input(farms)
        end
    end
  end

  @doc """
  Calcula a melhor rota usando o algoritmo do vizinho mais próximo
  """
  def calculate_route(farms) do
    IO.puts("\nCalculando a melhor rota entre #{length(farms)} fazendas...\n")

    # Começamos da primeira fazenda inserida
    start_farm = List.first(farms)

    # Calcula a rota usando o algoritmo do vizinho mais próximo
    route = nearest_neighbor_route(farms, [start_farm], MapSet.new([start_farm.id]))

    # Exibe a rota encontrada
    display_route(route)

    # Calcula e exibe a distância total
    total_distance = calculate_total_distance(route)
    IO.puts("\nDistância total da rota: #{Float.round(total_distance, 2)} km")
  end

  @doc """
  Implementação do algoritmo do vizinho mais próximo
  """
  def nearest_neighbor_route(all_farms, route, visited) when length(all_farms) == length(route) do
    route
  end

  def nearest_neighbor_route(all_farms, route, visited) do
    current = List.last(route)

    next_farm = all_farms
    |> Enum.filter(fn farm -> !MapSet.member?(visited, farm.id) end)
    |> Enum.min_by(fn farm ->
      calculate_distance(current.coordinates, farm.coordinates)
    end)

    updated_route = route ++ [next_farm]
    updated_visited = MapSet.put(visited, next_farm.id)

    nearest_neighbor_route(all_farms, updated_route, updated_visited)
  end

  @doc """
  Calcula a distância entre dois pontos usando a fórmula de Haversine
  """
  def calculate_distance({lat1, lon1}, {lat2, lon2}) do
    # Raio médio da Terra em quilômetros
    earth_radius = 6371

    # Converter para radianos
    lat1_rad = degrees_to_radians(lat1)
    lon1_rad = degrees_to_radians(lon1)
    lat2_rad = degrees_to_radians(lat2)
    lon2_rad = degrees_to_radians(lon2)

    # Diferenças
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    # Fórmula de Haversine
    a = :math.sin(dlat / 2) * :math.sin(dlat / 2) +
        :math.cos(lat1_rad) * :math.cos(lat2_rad) *
        :math.sin(dlon / 2) * :math.sin(dlon / 2)

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))

    # Distância em quilômetros
    earth_radius * c
  end

  @doc """
  Calcula a distância total de uma rota
  """
  def calculate_total_distance(route) do
    route
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [farm1, farm2], acc ->
      acc + calculate_distance(farm1.coordinates, farm2.coordinates)
    end)
  end

  @doc """
  Converte graus para radianos
  """
  defp degrees_to_radians(degrees) do
    degrees * :math.pi() / 180
  end

  @doc """
  Exibe a rota calculada
  """
  defp display_route(route) do
    IO.puts("Rota otimizada:")

    route
    |> Enum.with_index()
    |> Enum.each(fn {farm, index} ->
      IO.puts("#{index + 1}. Fazenda #{farm.id}: #{format_coordinates(farm.coordinates)}")
    end)
  end

  @doc """
  Tenta converter uma string em coordenadas geográficas
  """
  defp parse_coordinates(input) do
    try do
      [lat_str, lon_str] = String.split(input, ",", trim: true)
      lat = String.trim(lat_str) |> String.to_float()
      lon = String.trim(lon_str) |> String.to_float()

      # Validação básica de coordenadas
      if valid_coordinates?({lat, lon}) do
        {:ok, {lat, lon}}
      else
        :error
      end
    rescue
      _ -> :error
    end
  end

  @doc """
  Verifica se as coordenadas estão dentro de limites válidos
  """
  defp valid_coordinates?({lat, lon}) do
    lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180
  end

  @doc """
  Formata coordenadas para exibição
  """
  defp format_coordinates({lat, lon}) do
    "#{Float.round(lat, 4)}, #{Float.round(lon, 4)}"
  end
end

# Módulo de aplicação para iniciar o programa
defmodule FarmRouter do
  def start do
    FarmRouteOptimizer.main()
  end
end

# Para executar a aplicação:
# FarmRouter.start()
