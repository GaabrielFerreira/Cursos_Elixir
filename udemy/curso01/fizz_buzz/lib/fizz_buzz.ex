defmodule FizzBuzz do
  def build(file_name) do
    file_name
    |> File.read()
    |> handle_file_read()
  end

  defp handle_file_read({:ok, result}) do
    result =
     result
     |> String.split(",") #"1,2,3,4" -> [1,2,3,4]
     |> Enum.map(&convert_and_evaluate_numbers/1) #Converte cada Posicao para inteiro

     {:ok, result}
  end

  defp handle_file_read({:error, reason}), do: {:error, "Error reading the file #{reason}"}

  defp convert_and_evaluate_numbers(elem) do
    elem
    |> String.to_integer()
    |> evaluate_numbers()
  end

  #Divisivel por 3 e 5 por primeiro porque se apenas 3 ou 5 ficar acima e for verdadeiro, ele nao vai ser verificado (3 e 5)
  defp evaluate_numbers(number) when rem(number,3) == 0 and rem(number, 5) == 0, do: :fizzbuzz
  defp evaluate_numbers(number) when rem(number, 3) == 0, do: :fizz
  defp evaluate_numbers(number) when rem(number, 5) == 0, do: :buzz
  defp evaluate_numbers(number), do: number
end
