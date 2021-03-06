@testset "Build from string [sucess]" begin
    for ibanstr in map( cc -> iban_random(CountryCode=cc)["value"] ,supported_countries())
        @test iban(ibanstr)["value"] == ibanstr
    end
end


function test_error(iban_str, snippet)
        try
            iban(iban_str)      
        catch err
            @test err isa ValidationException
            @test occursin(snippet, sprint(showerror, err)) == true
            return
        end      
        error("Expected test to fail: ('$iban_str , $snippet)")  
    end
    
    
@testset "Build from string [error]" begin
        test_error("A", "value too short")
        test_error("XX", "value too short")
        test_error("AL1", "value too short")
        test_error("XX11", "country code not supported")
        # we use BR as it has a rich structure:
        # BR97 00360305 00001 0009795493 P 1
        test_error("BR9700360305000010009795493P1_", "unexpected BBAN length, expected:")
        # BankCode(EntrySpec(:N, 8)),
        test_error("BR970036030A000010009795493P1", "invalid characters [Iban.BankCode]")
        # BranchCode(EntrySpec(:N, 5)),
        test_error("BR97003603050000A0009795493P1", "invalid characters [Iban.BranchCode]")
        # AccountNumber(EntrySpec(:N, 10))
        test_error("BR970036030500001000979549AP1", "invalid characters [Iban.AccountNumber]")
        # AccountType(EntrySpec(:A, 1)),       
        test_error("BR970036030500001000979549391", "invalid characters [Iban.AccountType]")
        # OwnerAccountType(EntrySpec(:C, 1)
        test_error("BR9700360305000010009795493P_", "invalid characters [Iban.OwnerAccountType]")
        # Invalid check digits
        test_error("BR9900360305000010009795493P1", "invalid check digits")
        # Invalid check digits
        test_error("BR9700360305000010009795493P2", "invalid check digits")
    end


