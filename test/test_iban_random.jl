
function isvalid(subject::Dict{String, String}, display = false)
    if display
        println("isvalid: $subject")
    end
    typeof(iban(subject["value"])) == Dict{String,String}
end


@testset "iban_random         [one]" begin
    @test iban_random(
        CountryCode="BR"
    )["CountryCode"] == "BR"

    @test iban_random(
        CountryCode="BR", 
        BankCode="18731592"
    )["BankCode"] == "18731592"

    @test iban_random(
        CountryCode="BR", 
        BankCode="18731592",
        BranchCode = "89800"
    )["BranchCode"] == "89800"

    @test iban_random(
        CountryCode="BR", 
        BankCode="18731592",
        BranchCode = "89800",
        AccountNumber = "6427460610"
    )["AccountNumber"] == "6427460610"

    @test iban_random(
        CountryCode="BR", 
        BankCode="18731592",
        BranchCode = "89800",
        AccountNumber = "6427460610",
        AccountType = "X"
    )["AccountType"] == "X"

    @test iban_random(
        CountryCode="BR", 
        BankCode="18731592",
        BranchCode = "89800",
        AccountNumber = "6427460610",
        AccountType = "X",
        OwnerAccountType = "m",
    )["OwnerAccountType"] == "m"
end


@testset "iban_random         [all]" begin
     @test isvalid(iban_random()) == true
     @test isvalid(iban_random(CountryCode="BR", BankCode="18731592")) == true

      # all supported country codes
      map(cc ->
        (@test isvalid(iban_random(CountryCode=cc)) == true),
        supported_countries()
      )
end
