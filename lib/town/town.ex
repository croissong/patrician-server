defmodule Patrician.Town do
  require Logger
  alias Patrician.{Material, Materials}
  defstruct [:name, :materials, :comparison]

  def new(name, materials \\ %{}) do
    %Patrician.Town{name: name, materials: materials, comparison: []}
  end

  def receive_update(town_name, materials) do
    Logger.info("#{town_name} updated") 
    Agent.get_and_update(town_name,
      fn(town) ->
        get_and_update_in(town.materials, &{&1, {Map.merge(&1, materials)}})
        
        # for {key, value} <- materials do
        #   town = town |> Map.put(key, value) 
        # end
        {town, town}
      end
    )
  end

  def start_link(town) do 
    Agent.start_link(fn -> town end, name: town.name)
    Logger.info("Initialized #{town.name}")
  end
  
end

defmodule Patrician.Towns do
  @towns [:Luebeck, :Rostock]
  alias Patrician.{Town}
  
  
  def init() do
    for town <- @towns do
      Town.new(town) |> Town.start_link
    end 
  end 
end
  
