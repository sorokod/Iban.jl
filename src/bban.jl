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
  limitations under the License. =#

import Random.randstring
import Base.length

using Memoize

#= 
#############################################################

 EntrySpec spells out the specification for an entry .
 For example EntrySpec(:N, 5) is numeric of lenth 5
 and EntrySpec(:C, 16) is alphanumeric of lenth 16

############################################################# =#

const alphabets = Dict(
    :A => ['A':'Z';],
    :N => ['0':'9';],
    :C => vcat(['A':'Z';], ['0':'9';], ['a':'z';])
)

struct EntrySpec
    type::Symbol
    alphabet::Vector{Char}
    length::Int
    EntrySpec(type::Symbol, length::Int) = new(type, alphabets[type], length)
end


_sample(spec::EntrySpec)::String = randstring(spec.alphabet, spec.length)

#= 
#############################################################

 EntryType is a classification of IBAN entries as EntrySpecs
 according to domain types, e.g.: BankCode, BranchCode, etc...

############################################################# =#
abstract type EntryType end

struct BankCode <: EntryType
    spec::EntrySpec
end
struct BranchCode <: EntryType
    spec::EntrySpec
end
struct AccountNumber <: EntryType
    spec::EntrySpec
end
struct NationalCheckDigit <: EntryType
    spec::EntrySpec
end
struct AccountType <: EntryType
    spec::EntrySpec
end
struct OwnerAccountType <: EntryType
    spec::EntrySpec
end
struct IdentificationNumber <: EntryType
    spec::EntrySpec
end


stringify(iban_entry) = split(string(typeof(iban_entry.entry_type)), ".")[2]    

@memoize _symname(e::EntryType) = Symbol(typeof(e))

#= 
#############################################################

BbanStructure is an orderd collection of EntryTypes. Different
countries would have diffrenet structures

############################################################# =#
struct BbanStructure
    entries::Vector{EntryType}
end

##
## Return the length of the BbanStructure in characters
##
@memoize function _length(structure::BbanStructure)::Int 
    mapreduce(entry -> entry.spec.length, +, structure.entries)
end    

##
## [4 4 12] => [1:4, 5:8, 9:20]
##  
@memoize function _slicing(structure::BbanStructure)
    # println("XXX memoize_cache(_slicing): $(length(memoize_cache(_slicing)))")
    result = Tuple{Symbol,UnitRange}[]
    offset = 1

    map(structure.entries) do ent
        symbol = _symname(ent)
        push!(result, (symbol, UnitRange(offset, ent.spec.length + offset - 1)))
        offset += ent.spec.length
    end
    result
end    


function parse_bban!(countrycode, partup, allow_random_values=false)

    theiban = TheIban(countrycode)

    bban_structure = for_country(theiban.country_code)
    for entry in bban_structure.entries
        parkey = Symbol(typeof(entry))

        if allow_random_values && ( partup[parkey] === nothing )
            parval = _sample(entry.spec)
        else    
            parval = partup[parkey]
        end    
        
        push!(theiban.bban, IbanEntry(parval, entry))
    end

    theiban.bban_str = mapreduce(entry -> entry.value, *, values(theiban.bban))
    theiban
end


for_country(country_code)::Maybe{BbanStructure} =
   get(bban_structures_by_country, country_code, nothing)


   
"""
    is_supported_country(country_code)::Bool

Return a boolean indicating if the country identified by `country_code` is supported.

# Examples
```julia
julia> is_supported_country("DE")
true

julia> is_supported_country("ZZ")
false
```
"""
is_supported_country(country_code::AbstractString) =
    haskey(bban_structures_by_country, country_code)

"""
    supported_countries()::Array{String,1}

Return an array of supported country codes.
"""
@memoize supported_countries() = collect(keys(bban_structures_by_country))


# *******************
# https://www.swift.com/resource/iban-registry-pdf
# ::Dict{String,BbanStructure}

const bban_structures_by_country = Dict(
    "AD" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:C, 12)),
    ]),
    "AE" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "AL" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 4)),
        NationalCheckDigit(EntrySpec(:N, 1)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "AT" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:N, 11)),
    ]),
    "AZ" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 20)),
    ]),
    "BA" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 8)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "BE" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 7)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "BG" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountType(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:C, 8)),
    ]),
    "BH" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 14)),
    ]),
    "BR" => BbanStructure([
        BankCode(EntrySpec(:N, 8)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:N, 10)),
        AccountType(EntrySpec(:A, 1)),
        OwnerAccountType(EntrySpec(:C, 1)),
    ]),
    "BY" => BbanStructure([
        BankCode(EntrySpec(:C, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "CH" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 12)),
    ]),
    "CR" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 14)),
    ]),
    "CY" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "CZ" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 16)),
    ]),
    "DE" => BbanStructure([
        BankCode(EntrySpec(:N, 8)),
        AccountNumber(EntrySpec(:N, 10)),
    ]),
    "DK" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 10)),
    ]),
    "DO" => BbanStructure([
        BankCode(EntrySpec(:C, 4)),
        AccountNumber(EntrySpec(:N, 20)),
    ]),
    "EE" => BbanStructure([
        BankCode(EntrySpec(:N, 2)),
        BranchCode(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:N, 11)),
        NationalCheckDigit(EntrySpec(:N, 1)),
    ]),
    "ES" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        BranchCode(EntrySpec(:N, 4)),
        NationalCheckDigit(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:N, 10)),
    ]),
    "FI" => BbanStructure([
        BankCode(EntrySpec(:N, 6)),
        AccountNumber(EntrySpec(:N, 7)),
        NationalCheckDigit(EntrySpec(:N, 1)),
    ]),
    "FO" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 9)),
        NationalCheckDigit(EntrySpec(:N, 1)),
    ]),
    "FR" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 11)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "GB" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        BranchCode(EntrySpec(:N, 6)),
        AccountNumber(EntrySpec(:N, 8)),
    ]),
    "GE" => BbanStructure([
        BankCode(EntrySpec(:A, 2)),
        AccountNumber(EntrySpec(:N, 16)),
    ]),
    "GI" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 15)),
    ]),
    "GL" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 10)),
    ]),
    "GR" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "GT" => BbanStructure([
        BankCode(EntrySpec(:C, 4)),
        AccountNumber(EntrySpec(:C, 20)),
    ]),
    "HR" => BbanStructure([
        BankCode(EntrySpec(:N, 7)),
        AccountNumber(EntrySpec(:N, 10)),
    ]),
    "HU" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 16)),
        NationalCheckDigit(EntrySpec(:N, 1)),
    ]),
    "IE" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        BranchCode(EntrySpec(:N, 6)),
        AccountNumber(EntrySpec(:N, 8)),
    ]),
    "IL" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 13)),
    ]),
    "IR" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 19)),
    ]),
    "IS" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        BranchCode(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:N, 6)),
        IdentificationNumber(EntrySpec(:N, 10)),
    ]),
    "IT" => BbanStructure([
        NationalCheckDigit(EntrySpec(:A, 1)),
        BankCode(EntrySpec(:N, 5)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 12)),
    ]),
    "JO" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:C, 18)),
    ]),
    "KW" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 22)),
    ]),
    "KZ" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:C, 13)),
    ]),
    "LB" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:C, 20)),
    ]),
    "LC" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 24)),
    ]),
    "LI" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 12)),
    ]),
    "LT" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:N, 11)),
    ]),
    "LU" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:C, 13)),
    ]),
    "LV" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 13)),
    ]),
    "MC" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 11)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "MD" => BbanStructure([
        BankCode(EntrySpec(:C, 2)),
        AccountNumber(EntrySpec(:C, 18)),
    ]),
    "ME" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 13)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "MK" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:C, 10)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "MR" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:N, 11)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "MT" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 18)),
    ]),
    "MU" => BbanStructure([
        BankCode(EntrySpec(:C, 6)),
        BranchCode(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:C, 18)),
    ]),
    "NL" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:N, 10)),
    ]),
    "NO" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 6)),
        NationalCheckDigit(EntrySpec(:N, 1)),
    ]),
    "PK" => BbanStructure([
        BankCode(EntrySpec(:C, 4)),
        AccountNumber(EntrySpec(:N, 16)),
    ]),
    "PL" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        BranchCode(EntrySpec(:N, 4)),
        NationalCheckDigit(EntrySpec(:N, 1)),
        AccountNumber(EntrySpec(:N, 16)),
    ]),
    "PS" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 21)),
    ]),
    "PT" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 11)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "QA" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 21)),
    ]),
    "RO" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "RS" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 13)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "SA" => BbanStructure([
        BankCode(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:C, 18)),
    ]),
    "SC" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 16)),
        AccountType(EntrySpec(:A, 3)),
    ]),
    "SE" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 17)),
    ]),
    "SI" => BbanStructure([
        BankCode(EntrySpec(:N, 2)),
        BranchCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 8)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "SK" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 16)),
    ]),
    "SM" => BbanStructure([
        NationalCheckDigit(EntrySpec(:A, 1)),
        BankCode(EntrySpec(:N, 5)),
        BranchCode(EntrySpec(:N, 5)),
        AccountNumber(EntrySpec(:C, 12)),
    ]),
    "ST" => BbanStructure([
        BankCode(EntrySpec(:N, 4)),
        BranchCode(EntrySpec(:N, 4)),
        AccountNumber(EntrySpec(:N, 13)),
    ]),
    "SV" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:N, 20)),
    ]),
    "TL" => BbanStructure([
        BankCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:N, 14)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
    "TN" => BbanStructure([
        BankCode(EntrySpec(:N, 2)),
        BranchCode(EntrySpec(:N, 3)),
        AccountNumber(EntrySpec(:C, 15)),
    ]),
    "TR" => BbanStructure([
        BankCode(EntrySpec(:N, 5)),
        NationalCheckDigit(EntrySpec(:C, 1)),
        AccountNumber(EntrySpec(:C, 16)),
    ]),
    "UA" => BbanStructure([
        BankCode(EntrySpec(:N, 6)),
        AccountNumber(EntrySpec(:N, 19)),
    ]),
    "VG" => BbanStructure([
        BankCode(EntrySpec(:A, 4)),
        AccountNumber(EntrySpec(:N, 16)),
    ]),
    "XK" => BbanStructure([
        BankCode(EntrySpec(:N, 2)),
        BranchCode(EntrySpec(:N, 2)),
        AccountNumber(EntrySpec(:N, 10)),
        NationalCheckDigit(EntrySpec(:N, 2)),
    ]),
)
