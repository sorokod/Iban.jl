# Iban.jl 

A Julia package for generating and validating IBANs. 

The International Bank Account Number standard is described in Wikipedia in some detail, see the [Reference](@ref)  
section. 

An IBAN consists of a two character country code, followed by a two digit redundancy code (AKA "check 
digits"), followed by a Basic Bank Account Number (BBAN) – an up to 30 alphanumeric character long string that is 
country specific. 

The overall IBAN structure is then `<country code><check digits><BBAN>`. The country-by-country attribute format of the
`BBAN`s is captured in the IBAN registry document. All countries define a `BankCode` and `AccountNumber` structures, but 
some have additional attributes such as `BranchCode`, `NationalCheckDigit`, `AccountType` and `IdentificationNumber`. 

**Iban.jl** is aware of these definitions and takes them into account when parsing and validating the input. The IBAN 
generating functions ( [`iban`](@ref) and [`iban_random`](@ref) ) return a dictionary with keys that are the BBAN 
attribute names along with: `CountryCode`, `CheckDigits`and `value`. The last one is the string representation of the IBAN:

```julia
julia> iban_random(CountryCode = "DE")
Dict{String,String} with 5 entries:
  "CountryCode"   => "DE"
  "AccountNumber" => "2619193797"
  "value"         => "DE37570047482619193797"
  "BankCode"      => "57004748"
  "CheckDigits"   => "37"
```

All functions will throw a `DomainError` if they fail to validate the input, for example:

```julia
julia> iban_random(CountryCode = "DE", BankCode = "XX004748")
ERROR: DomainError with value: XX004748:
invalid characters [Iban.BankCode]
```






```@docs
iban
iban_random
is_supported_country
supported_countries
```

---

## Reference

- [International Bank Account Number (Wikipedia)](http://en.wikipedia.org/wiki/ISO_13616)
- [The ISO_3166 Country code standard](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
- [IBAN Registry (PDF)](https://www.swift.com/resource/iban-registry-pdf)


---

## Lineage

**Iban.jl** is a port of [Iban4j](https://github.com/arturmkrtchyan/iban4j) Java library which is published under 
Apache 2 license and copyrighted 2015 Artur Mkrtchyan

---

## License

Copyright 2021 David Soroko except where stated otherwise in the source.

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)