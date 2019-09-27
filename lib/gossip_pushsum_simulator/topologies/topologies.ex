defmodule GPS.Topologies do
  def build_topologies(list_nodes, topology_type) do
    case topology_type do
      :line -> build_line_topology(list_nodes)
      :full -> build_full_topology(list_nodes)
    end
  end

  def build_full_topology(list_nodes) do
    for elem <- list_nodes do
      GenServer.cast(elem, {:set_neighbours, list_nodes -- [elem]})
    end
  end

  def build_line_topology(list_nodes) do
    num_nodes = length(list_nodes)

    for i <- 0..(num_nodes - 1) do
      cond do
        i == 0 -> line_topology_helper(list_nodes, [i, i + 1])
        i == num_nodes - 1 -> line_topology_helper(list_nodes, [i, i - 1])
        true -> line_topology_helper(list_nodes, [i, i - 1, i + 1])
      end
    end
  end

  defp line_topology_helper(list_nodes, neighborhood) do
    [self_index | neighbors_index] = neighborhood

    neighbors =
      for i <- neighbors_index do
        Enum.at(list_nodes, i)
      end

    GenServer.cast(Enum.at(list_nodes, self_index), {:set_neighbours, neighbors})
  end
end