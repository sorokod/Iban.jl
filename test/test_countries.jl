@testset "Countries      [supported]" begin
    @test length(supported_countries()) == 75
    
    map(cc -> (@test is_supported_country(cc) == true), supported_countries())
end

@testset "Countries  [not supported]" begin
    @test is_supported_country("DEU") == false
    @test is_supported_country("GBR") == false
    @test is_supported_country("AA") == false
    @test is_supported_country("XX") == false
end
