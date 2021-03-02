module Iban

include("common.jl")
include("check_digits.jl")
include("bban.jl")

export is_supported_country, supported_countries
export iban, iban_random, build

"""
    iban_random(
        CountryCode::Maybe{String}=nothing,
        BankCode::Maybe{String}=nothing,
        AccountNumber::Maybe{String}=nothing,
        BranchCode::Maybe{String}=nothing,
        NationalCheckDigit::Maybe{String}=nothing,
        AccountType::Maybe{String}=nothing,
        OwnerAccountType::Maybe{String}=nothing,
        IdentificationNumber::Maybe{String}=nothing
    )::Dict{String,String}

Generate a random IBAN subject to the provided constraints. For a constraint that is not provided a
random value will be used according to the rules of the (provided or generated) country. Constraints
that are irrelevant for a country are ignored.

Failure to validate will result in a `domainError`

# Example
```julia
julia> iban_random()
Dict{String,String} with 6 entries:
  "CountryCode"   => "GR"
  "BranchCode"    => "7500"
  "AccountNumber" => "1HRB7OApF5ABTOYH"
  "value"         => "GR8410975001HRB7OApF5ABTOYH"
  "BankCode"      => "109"
  "CheckDigits"   => "84"

julia> iban_random(CountryCode = "GR", BankCode = "109")
Dict{String,String} with 6 entries:
  "CountryCode"   => "GR"
  "BranchCode"    => "2170"
  "AccountNumber" => "24wO2qBgz1ROP82L"
  "value"         => "GR26109217024wO2qBgz1ROP82L"
  "BankCode"      => "109"
  "CheckDigits"   => "26"

```
"""
function iban_random(;
    CountryCode::Maybe{String}=nothing,
    BankCode::Maybe{String}=nothing,
    AccountNumber::Maybe{String}=nothing,
    BranchCode::Maybe{String}=nothing,
    NationalCheckDigit::Maybe{String}=nothing,
    AccountType::Maybe{String}=nothing,
    OwnerAccountType::Maybe{String}=nothing,
    IdentificationNumber::Maybe{String}=nothing
)::Dict{String,String}  

    partup = (;
        Symbol("Iban.BankCode") => BankCode,
        Symbol("Iban.AccountNumber") => AccountNumber,
        Symbol("Iban.BranchCode") => BranchCode,
        Symbol("Iban.NationalCheckDigit") => NationalCheckDigit,
        Symbol("Iban.AccountType") => AccountType,
        Symbol("Iban.OwnerAccountType") => OwnerAccountType,
        Symbol("Iban.IdentificationNumber") => IdentificationNumber
    )

    country_code = CountryCode === nothing ? rand(supported_countries()) : CountryCode
    ensure(
        is_supported_country(country_code),
        country_code, "country not supported"
    )

    theiban = TheIban(country_code)

    parse_bban(theiban, partup, true)

    theiban.check_digits = calculate_check_digit(
        theiban.bban_str,
        theiban.country_code
    )

    theiban.iban_str =
        theiban.country_code * theiban.check_digits * theiban.bban_str

    as_dict(theiban)
end


"""
    iban(
        CountryCode::String,
        BankCode::String,
        AccountNumber::String,
        BranchCode::Maybe{String}=nothing,
        NationalCheckDigit::Maybe{String}=nothing,
        AccountType::Maybe{String}=nothing,
        OwnerAccountType::Maybe{String}=nothing,
        IdentificationNumber::Maybe{String}=nothing,
    )::Dict{String,String}

 Generate an IBAN based on the provided parameters.
 
 Parsing may fail validation in which case a `DomainError` is thrown.

# Example
```julia
julia> iban(CountryCode = "GB", BankCode = "NWBK", BranchCode = "601613",AccountNumber = "31926819")
Dict{String,String} with 6 entries:
  "CountryCode"   => "GB"
  "BranchCode"    => "601613"
  "AccountNumber" => "31926819"
  "value"         => "GB29NWBK60161331926819"
  "BankCode"      => "NWBK"
  "CheckDigits"   => "29"  
  
julia> iban(CountryCode = "GB", BankCode = "NWBK", AccountNumber = "31926819")
ERROR: DomainError with value: nothing:
Value not provided [Iban.BranchCode]
```
"""
function iban(;
    CountryCode::String,
    BankCode::String,
    AccountNumber::String,
    BranchCode::Maybe{String}=nothing,
    NationalCheckDigit::Maybe{String}=nothing,
    AccountType::Maybe{String}=nothing,
    OwnerAccountType::Maybe{String}=nothing,
    IdentificationNumber::Maybe{String}=nothing
)::Dict{String,String}
 
    partup = (;
        Symbol("Iban.BankCode") => BankCode,
        Symbol("Iban.AccountNumber") => AccountNumber,
        Symbol("Iban.BranchCode") => BranchCode,
        Symbol("Iban.NationalCheckDigit") => NationalCheckDigit,
        Symbol("Iban.AccountType") => AccountType,
        Symbol("Iban.OwnerAccountType") => OwnerAccountType,
        Symbol("Iban.IdentificationNumber") => IdentificationNumber
        )

    theiban = TheIban(CountryCode)
    parse_bban(theiban, partup)

    theiban.check_digits = calculate_check_digit(
        theiban.bban_str,
        theiban.country_code
    )

    theiban.iban_str =
        theiban.country_code * theiban.check_digits * theiban.bban_str

    as_dict(theiban)
end



#
# ============= From String ===================
#
const CHECK_DIGIT_LENGTH = 2
const CHECK_DIGIT_RANGE = 3:4
const COUNTRY_CODE_LENGTH = 2
const COUNTRY_CODE_RANGE = 1:2
const BBAN_INDEX = COUNTRY_CODE_LENGTH + CHECK_DIGIT_LENGTH + 1


"""
    iban(iban_str::String)::Dict{String,String}

Generate an IBAN from the provided string.     
 
Parsing may fail validation in which case a `DomainError` is thrown.

# Example
```julia    
julia> iban("BR9700360305000010009795493P1")
Dict{String,String} with 8 entries:
  "CountryCode"      => "BR"
  "CheckDigits"      => "97"
  "BranchCode"       => "00001"
  "AccountType"      => "P"
  "AccountNumber"    => "0009795493"
  "value"            => "BR9700360305000010009795493P1"
  "BankCode"         => "00360305"
  "OwnerAccountType" => "1"

julia> iban("BR9900360305000010009795493P1")
  ERROR: DomainError with value: 99:
  invalid check_digits, expected: 97  
```      
"""
function iban(iban_str::String)::Dict{String,String}

    ensure(
        length(iban_str) >= COUNTRY_CODE_LENGTH + CHECK_DIGIT_LENGTH,
        iban_str, "value too short"
    )

    country_code = SubString(iban_str, COUNTRY_CODE_RANGE)
    bban_structure = for_country(country_code)
    ensure(
        bban_structure !== nothing,
        country_code, "country code not supported"
    )

    bban_str = SubString(iban_str, BBAN_INDEX)
    ensure(
        length(bban_structure) == length(bban_str),
        bban_str, "unexpected BBAN length, expected: $(length(bban_structure))"
    )

    theiban = TheIban(country_code)
    dict = Dict()

    bban_entry_offset = 1
    for entry in bban_structure.entries
        entry_length = entry.spec.length
        entry_value = SubString(
            bban_str,
            bban_entry_offset,
            bban_entry_offset + entry_length - 1,
        )
        
        dict[Symbol(string(typeof(entry)))] = entry_value

        bban_entry_offset += entry_length
    end

    partup = NamedTuple{ Tuple(keys(dict)) }(values(dict))
    parse_bban(theiban, partup)

    provided_check_digits = SubString(iban_str, CHECK_DIGIT_RANGE)
    expected = calculate_check_digit(bban_str, country_code)
    ensure(
        expected == provided_check_digits,
        provided_check_digits, "invalid check digits, expected: $(expected)" 
    )

    theiban.check_digits = expected
    theiban.iban_str = iban_str
    
    as_dict(theiban)
end



struct IbanEntry
    value::AbstractString
    entry_type::EntryType
    function IbanEntry(value, entry_type)        
        ensure(
            !isnothing(value),
            value, "Value not provided [$(typeof(entry_type))]"
        )
        ensure(
            length(value) == entry_type.spec.length,
            value, "Unexpected length $(length(value)), expected: $(entry_type.spec.length) [$(typeof(entry_type))]"
        )
        ensure(
            issubset(value, entry_type.spec.alphabet),
            value, "invalid characters [$(typeof(entry_type))]"
        )
        new(value, entry_type)
    end 
end


mutable struct TheIban
    country_code::String
    check_digits::String
    bban::Vector{IbanEntry}
    bban_str::Maybe{String}
    iban_str::Maybe{String}

    TheIban(country_code) = new(country_code, "00", [], nothing, nothing)
end


"""
    as_dict(theiban::TheIban) -> Dict{String,String}

Converts the internal IBAN representation to a `Dict`
"""
function as_dict(theiban::TheIban)::Dict{String,String}
    result = Dict(stringify(entry) => entry.value for entry in values(theiban.bban))
    result["CountryCode"] = theiban.country_code
    result["CheckDigits"] = theiban.check_digits
    result["value"] = theiban.iban_str
    result
end


end
