#=
  Copyright 2013 Artur Mkrtchyan

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
=#


function calculate_check_digit(bban, country_code)::String
    combined = bban * country_code * "00"
    check_digits = 98 - mod_97(combined)
    lpad(check_digits, 2, "0")
end


# [0..9] are matched to values:            [0..9]
# [a..z] and [A..Z] are matched to values: [10..35]
const zero_to_Z = vcat(['0':'9';], ['A':'Z';])
const a_to_z = ['a':'z';]
const c_to_numeric = merge(
    Dict(zero_to_Z[i] => i - 1 for i = 1:length(zero_to_Z)),
    Dict(a_to_z[i] => i + 9 for i = 1:length(a_to_z)),
)
const NINE_NINES = 999999999

function mod_97(str)
    total = 0
    for c in str
        c_numeric = c_to_numeric[c]
        total = (c_numeric > 9 ? total * 100 : total * 10) + c_numeric
        if total > NINE_NINES
            total = mod(total, 97)
        end
    end
    mod(total, 97)
end

# according to @btime, about of order of magnitude more expensive 
# then mod_97
function mod_97_bigint(str)
    numeric_str = map(c -> alphabet_to_numeric[c] , collect(str)) |> join
    numeric_bi = parse(BigInt, numeric_str)
    mod(numeric_bi, 97)
end