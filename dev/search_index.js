var documenterSearchIndex = {"docs":
[{"location":"#Iban.jl","page":"Iban.jl","title":"Iban.jl","text":"","category":"section"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"A Julia package for generating and validating IBANs. ","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"The International Bank Account Number standard is described in Wikipedia in some detail, see Reference. ","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"An IBAN consists of a two character country code, followed by a two digit redundancy code (AKA \"check  digits\"), followed by a Basic Bank Account Number (BBAN) – an up to 30 alphanumeric character long string that is  country specific. ","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"The overall IBAN structure is then <country code><check digits><BBAN>. The country-by-country attribute format of the BBANs is captured in the IBAN registry document. All countries define a BankCode and AccountNumber structures, but some have additional attributes such as BranchCode, NationalCheckDigit, AccountType and IdentificationNumber. ","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"Iban.jl is aware of these definitions and takes them into account when parsing and validating the input. The IBAN  generating functions ( iban and iban_random ) return a dictionary with keys that are the BBAN  attribute names along with: CountryCode, CheckDigitsand value. The last one is the string representation of the IBAN:","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"julia> iban_random(CountryCode = \"DE\")\nDict{String,String} with 5 entries:\n  \"CountryCode\"   => \"DE\"\n  \"AccountNumber\" => \"2619193797\"\n  \"value\"         => \"DE37570047482619193797\"\n  \"BankCode\"      => \"57004748\"\n  \"CheckDigits\"   => \"37\"","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"IBAN generating functions, will throw a ValidationException if they fail to validate the input, for example:","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"julia> iban_random(CountryCode = \"DE\", BankCode = \"XX004748\")\nERROR: ValidationException value: \"XX004748\"\ninvalid characters [Iban.BankCode]```","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"","category":"page"},{"location":"#Library","page":"Iban.jl","title":"Library","text":"","category":"section"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"iban\niban_random\nis_supported_country\nsupported_countries\nValidationException","category":"page"},{"location":"#Iban.iban","page":"Iban.jl","title":"Iban.iban","text":"iban(\n    CountryCode::String,\n    BankCode::String,\n    AccountNumber::String,\n    BranchCode::Maybe{String}=nothing,\n    NationalCheckDigit::Maybe{String}=nothing,\n    AccountType::Maybe{String}=nothing,\n    OwnerAccountType::Maybe{String}=nothing,\n    IdentificationNumber::Maybe{String}=nothing,\n)::Dict{String,String}\n\nGenerate an IBAN based on the provided parameters.\n\nExample\n\njulia> iban(CountryCode = \"GB\", BankCode = \"NWBK\", BranchCode = \"601613\",AccountNumber = \"31926819\")\nDict{String,String} with 6 entries:\n  \"CountryCode\"   => \"GB\"\n  \"BranchCode\"    => \"601613\"\n  \"AccountNumber\" => \"31926819\"\n  \"value\"         => \"GB29NWBK60161331926819\"\n  \"BankCode\"      => \"NWBK\"\n  \"CheckDigits\"   => \"29\"  \n  \n\n\n\n\n\niban(iban_str::String)::Dict{String,String}\n\nGenerate an IBAN from the provided string.     \n\nExample\n\njulia> iban(\"BR9700360305000010009795493P1\")\nDict{String,String} with 8 entries:\n  \"CountryCode\"      => \"BR\"\n  \"CheckDigits\"      => \"97\"\n  \"BranchCode\"       => \"00001\"\n  \"AccountType\"      => \"P\"\n  \"AccountNumber\"    => \"0009795493\"\n  \"value\"            => \"BR9700360305000010009795493P1\"\n  \"BankCode\"         => \"00360305\"\n  \"OwnerAccountType\" => \"1\"\n\n\n\n\n\n\n","category":"function"},{"location":"#Iban.iban_random","page":"Iban.jl","title":"Iban.iban_random","text":"iban_random(\n    CountryCode::Maybe{String}=nothing,\n    BankCode::Maybe{String}=nothing,\n    AccountNumber::Maybe{String}=nothing,\n    BranchCode::Maybe{String}=nothing,\n    NationalCheckDigit::Maybe{String}=nothing,\n    AccountType::Maybe{String}=nothing,\n    OwnerAccountType::Maybe{String}=nothing,\n    IdentificationNumber::Maybe{String}=nothing\n)::Dict{String,String}\n\nGenerate a random IBAN subject to the provided attributes. For an attributes that is not provided, a random value will be used according to the rules of the (provided or generated) country. Attributes that are not defined for a country are ignored.\n\nExample\n\njulia> iban_random()\nDict{String,String} with 6 entries:\n  \"CountryCode\"   => \"GR\"\n  \"BranchCode\"    => \"7500\"\n  \"AccountNumber\" => \"1HRB7OApF5ABTOYH\"\n  \"value\"         => \"GR8410975001HRB7OApF5ABTOYH\"\n  \"BankCode\"      => \"109\"\n  \"CheckDigits\"   => \"84\"\n\njulia> iban_random(CountryCode = \"GR\", BankCode = \"109\")\nDict{String,String} with 6 entries:\n  \"CountryCode\"   => \"GR\"\n  \"BranchCode\"    => \"2170\"\n  \"AccountNumber\" => \"24wO2qBgz1ROP82L\"\n  \"value\"         => \"GR26109217024wO2qBgz1ROP82L\"\n  \"BankCode\"      => \"109\"\n  \"CheckDigits\"   => \"26\"\n\n\n\n\n\n\n","category":"function"},{"location":"#Iban.is_supported_country","page":"Iban.jl","title":"Iban.is_supported_country","text":"is_supported_country(country_code)::Bool\n\nReturn a boolean indicating if the country identified by country_code is supported.\n\nExamples\n\njulia> is_supported_country(\"DE\")\ntrue\n\njulia> is_supported_country(\"ZZ\")\nfalse\n\n\n\n\n\n","category":"function"},{"location":"#Iban.supported_countries","page":"Iban.jl","title":"Iban.supported_countries","text":"supported_countries()::Array{String,1}\n\nReturn an array of supported country codes.\n\n\n\n\n\n","category":"function"},{"location":"#Iban.ValidationException","page":"Iban.jl","title":"Iban.ValidationException","text":"ValidationException\n\nThrown when parameters to generate an IBAN fail validation. Reports the problematic value and the matching BBAN attribute\n\nExample\n\njulia> iban_random(CountryCode = \"GR\", BankCode = \"xxx\")\nERROR: ValidationException value: \"xxx\"\ninvalid characters [Iban.BankCode]  \n\n\n\n\n\n","category":"type"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"","category":"page"},{"location":"#Reference","page":"Iban.jl","title":"Reference","text":"","category":"section"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"International Bank Account Number (Wikipedia)\nThe ISO_3166 Country code standard\nIBAN Registry (PDF)","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"","category":"page"},{"location":"#License","page":"Iban.jl","title":"License","text":"","category":"section"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"Iban.jl is a port of iban4j, a Java library published under  Apache 2 license and copyrighted 2015 Artur Mkrtchyan","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"Copyright 2021 David Soroko except where stated otherwise in the source.","category":"page"},{"location":"","page":"Iban.jl","title":"Iban.jl","text":"Licensed under the Apache License, Version 2.0","category":"page"}]
}
