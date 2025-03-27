defmodule Bananex.Tks do

  def call do
    # Task.start(&heavy_work/0)
    # light_work()

    task = Task.async((&heavy_work/0))
    res2 = light_work()
    res2 + Task.await(task)
  end

  defp heavy_work() do
    :timer.sleep(1000) #1000ms ou 1s
    IO.inspect("Heavy work")
    5
  end

  defp light_work() do
    :timer.sleep((500)) #0,5s
    IO.inspect("Light Work")
    2
  end
end
