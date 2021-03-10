module IbanGen

include("common.jl")
include("check_digits.jl")
include("bban.jl")

export is_supported_country, supported_countries
export iban, iban_random, build
export ValidationException

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

Generate a random IBAN subject to the provided attributes. For an attributes that is not provided, a
random value will be used according to the rules of the (provided or generated) country. Attributes
that are not defined for a country are ignored.


## Example
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
    CountryCode::MaybeString=nothing,
    BankCode::MaybeString=nothing,
    AccountNumber::MaybeString=nothing,
    BranchCode::MaybeString=nothing,
    NationalCheckDigit::MaybeString=nothing,
    AccountType::MaybeString=nothing,
    OwnerAccountType::MaybeString=nothing,
    IdentificationNumber::MaybeString=nothing
)::Dict{String,String}  

    partup = (;
        Symbol("IbanGen.BankCode") => BankCode,
        Symbol("IbanGen.AccountNumber") => AccountNumber,
        Symbol("IbanGen.BranchCode") => BranchCode,
        Symbol("IbanGen.NationalCheckDigit") => NationalCheckDigit,
        Symbol("IbanGen.AccountType") => AccountType,
        Symbol("IbanGen.OwnerAccountType") => OwnerAccountType,
        Symbol("IbanGen.IdentificationNumber") => IdentificationNumber
    )

    country_code = CountryCode === nothing ? rand(supported_countries()) : CountryCode

    theiban = parse_bban!(country_code, partup, true)

    theiban.check_digits = calculate_check_digit(
        theiban.bban_str,
        theiban.country_code
    )

    theiban.iban_str =
        theiban.country_code * theiban.check_digits * theiban.bban_str

    _as_dict(theiban)
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
 

## Example
```julia
julia> iban(CountryCode = "GB", BankCode = "NWBK", BranchCode = "601613",AccountNumber = "31926819")
Dict{String,String} with 6 entries:
  "CountryCode"   => "GB"
  "BranchCode"    => "601613"
  "AccountNumber" => "31926819"
  "value"         => "GB29NWBK60161331926819"
  "BankCode"      => "NWBK"
  "CheckDigits"   => "29"  
  
```
"""
function iban(;
    CountryCode::String,
    BankCode::String,
    AccountNumber::String,
    BranchCode::MaybeString=nothing,
    NationalCheckDigit::MaybeString=nothing,
    AccountType::MaybeString=nothing,
    OwnerAccountType::MaybeString=nothing,
    IdentificationNumber::MaybeString=nothing
)::Dict{String,String}
 
    partup = (;
        Symbol("IbanGen.BankCode") => BankCode,
        Symbol("IbanGen.AccountNumber") => AccountNumber,
        Symbol("IbanGen.BranchCode") => BranchCode,
        Symbol("IbanGen.NationalCheckDigit") => NationalCheckDigit,
        Symbol("IbanGen.AccountType") => AccountType,
        Symbol("IbanGen.OwnerAccountType") => OwnerAccountType,
        Symbol("IbanGen.IdentificationNumber") => IdentificationNumber
    )

    theiban = parse_bban!(CountryCode, partup)

    theiban.check_digits = calculate_check_digit(
        theiban.bban_str,
        theiban.country_code
    )

    theiban.iban_str =
        theiban.country_code * theiban.check_digits * theiban.bban_str
        
    _as_dict(theiban)
end


"""
    iban(iban_str::String)::Dict{String,String}

Generate an IBAN from the provided string.     
 
## Example
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

```      
"""
function iban(iban_str::String)::Dict{String,String}

    ensure(
        length(iban_str) >= 4,
        iban_str, "value too short"
    )

    country_code = SubString(iban_str, 1, 2)
    bban_structure = for_country(country_code)
    ensure(
        bban_structure !== nothing,
        country_code, "country code not supported"
    )

    bban_str = SubString(iban_str, 5)
    ensure(
        _length(bban_structure) == length(bban_str),
        bban_str, "unexpected BBAN length, expected: $(_length(bban_structure))"
    )

    
    dict = Dict(slice[1] => bban_str[slice[2]] for slice in _slicing(bban_structure))
    theiban = parse_bban!(country_code, dict)

    provided = SubString(iban_str, 3, 4)
    expected = calculate_check_digit(bban_str, country_code)
    ensure(
        expected == provided,
        provided, "invalid check digits, expected: $(expected)" 
    )

    theiban.check_digits = expected
    theiban.iban_str = iban_str
    
    _as_dict(theiban)
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
    bban_str::MaybeString
    iban_str::MaybeString

    function TheIban(country_code) 
        ensure(
            is_supported_country(country_code),
            country_code, "country code not supported"
        )
        new(country_code, "00", [], nothing, nothing)
    end
end


#=
#############################################################
Converts the internal IBAN representation to a `Dict`
#############################################################
=#
function _as_dict(theiban::TheIban)::Dict{String,String}
    result = Dict(stringify(entry) => entry.value for entry in values(theiban.bban))
    result["CountryCode"] = theiban.country_code
    result["CheckDigits"] = theiban.check_digits
    result["value"] = theiban.iban_str
    result
end


end
