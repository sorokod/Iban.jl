@testset "iban                [one]" begin
        result = iban(
                CountryCode="AL",
                BankCode="212",
                BranchCode="1100",
                AccountNumber="0000000235698741",
                NationalCheckDigit="9"
        )   
        @test result["CountryCode"] == "AL"
        @test result["BankCode"] == "212"
        @test result["BranchCode"] == "1100"
        @test result["AccountNumber"] == "0000000235698741"
        @test result["NationalCheckDigit"] == "9"
        @test result["value"] == "AL47212110090000000235698741"
end

@testset "iban                [all]" begin
        @test iban(
                CountryCode="AL",
                BankCode="212",
                BranchCode="1100",
                AccountNumber="0000000235698741",
                NationalCheckDigit="9",
        )["value"] == "AL47212110090000000235698741"
        @test iban(
                CountryCode="AD",
                BankCode="0001",
                BranchCode="2030",
                AccountNumber="200359100100",
        )["value"] == "AD1200012030200359100100"
        @test iban(
                CountryCode="AT",
                BankCode="19043",
                AccountNumber="00234573201",
        )["value"] == "AT611904300234573201"
        @test iban(
                CountryCode="AZ",
                BankCode="NABZ",
                AccountNumber="00000000137010001944",
        )["value"] == "AZ21NABZ00000000137010001944"
        @test iban(
                CountryCode="BH",
                BankCode="SCBL",
                AccountNumber="BHD18903608801",
        )["value"] == "BH72SCBLBHD18903608801"
        @test iban(
                CountryCode="BE",
                BankCode="539",
                AccountNumber="0075470",
                NationalCheckDigit="34",
        )["value"] == "BE68539007547034"
        @test iban(
                CountryCode="BA",
                BankCode="129",
                BranchCode="007",
                AccountNumber="94010284",
                NationalCheckDigit="94",
        )["value"] == "BA391290079401028494"
        @test iban(
                CountryCode="BR",
                BankCode="00360305",
                BranchCode="00001",
                AccountNumber="0009795493",
                AccountType="P",
                OwnerAccountType="1",
        )["value"] == "BR9700360305000010009795493P1"
        @test iban(
                CountryCode="BG",
                BankCode="BNBG",
                BranchCode="9661",
                AccountNumber="20345678",
                AccountType="10",
        )["value"] == "BG80BNBG96611020345678"
        @test iban(
                CountryCode="BY",
                BankCode="NBRB",
                BranchCode="3600",
                AccountNumber="900000002Z00AB00",
        )["value"] == "BY13NBRB3600900000002Z00AB00"
        @test iban(
                CountryCode="CR",
                BankCode="0152",
                AccountNumber="02001026284066",
        )["value"] == "CR05015202001026284066"
        @test iban(
                CountryCode="HR",
                BankCode="1001005",
                AccountNumber="1863000160",
        )["value"] == "HR1210010051863000160"
        @test iban(
                CountryCode="CY",
                BankCode="002",
                BranchCode="00128",
                AccountNumber="0000001200527600",
        )["value"] == "CY17002001280000001200527600"
        @test iban(
                CountryCode="CZ",
                BankCode="0800",
                AccountNumber="0000192000145399",
        )["value"] == "CZ6508000000192000145399"
        @test iban(
                CountryCode="DK",
                BankCode="0040",
                AccountNumber="0440116243",
        )["value"] == "DK5000400440116243"
        @test iban(
                CountryCode="DO",
                BankCode="BAGR",
                AccountNumber="00000001212453611324",
        )["value"] == "DO28BAGR00000001212453611324"
        @test iban(
                CountryCode="EE",
                BankCode="22",
                BranchCode="00",
                AccountNumber="22102014568",
                NationalCheckDigit="5",
        )["value"] == "EE382200221020145685"
        @test iban(
                CountryCode="FI",
                BankCode="123456",
                AccountNumber="0000078",
                NationalCheckDigit="5",
        )["value"] == "FI2112345600000785"
        @test iban(
                CountryCode="FR",
                BankCode="20041",
                BranchCode="01005",
                AccountNumber="0500013M026",
                NationalCheckDigit="06",
        )["value"] == "FR1420041010050500013M02606"
        @test iban(
                CountryCode="GE",
                BankCode="NB",
                AccountNumber="0000000101904917",
        )["value"] == "GE29NB0000000101904917"
        @test iban(
                CountryCode="DE",
                BankCode="37040044",
                AccountNumber="0532013000",
        )["value"] == "DE89370400440532013000"
        @test iban(
                CountryCode="GI",
                BankCode="NWBK",
                AccountNumber="000000007099453",
        )["value"] == "GI75NWBK000000007099453"
        @test iban(
                CountryCode="GR",
                BankCode="011",
                BranchCode="0125",
                AccountNumber="0000000012300695",
        )["value"] == "GR1601101250000000012300695"
        @test iban(
                CountryCode="GT",
                BankCode="TRAJ",
                AccountNumber="01020000001210029690",
        )["value"] == "GT82TRAJ01020000001210029690"
        @test iban(
                CountryCode="HU",
                BankCode="117",
                BranchCode="7301",
                AccountNumber="6111110180000000",
                NationalCheckDigit="0",
        )["value"] == "HU42117730161111101800000000"
        @test iban(
                CountryCode="IS",
                BankCode="0159",
                BranchCode="26",
                AccountNumber="007654",
                IdentificationNumber="5510730339",
        )["value"] == "IS140159260076545510730339"
        @test iban(
                CountryCode="IE",
                BankCode="AIBK",
                BranchCode="931152",
                AccountNumber="12345678",
        )["value"] == "IE29AIBK93115212345678"
        @test iban(
                CountryCode="IL",
                BankCode="010",
                BranchCode="800",
                AccountNumber="0000099999999",
        )["value"] == "IL620108000000099999999"
        @test iban(
                CountryCode="IT",
                BankCode="05428",
                BranchCode="11101",
                NationalCheckDigit="X",
                AccountNumber="000000123456",
        )["value"] == "IT60X0542811101000000123456"
        @test iban(
                CountryCode="JO",
                BankCode="CBJO",
                BranchCode="0010",
                AccountNumber="000000000131000302",
        )["value"] == "JO94CBJO0010000000000131000302"
        @test iban(
                CountryCode="KZ",
                BankCode="125",
                AccountNumber="KZT5004100100",
        )["value"] == "KZ86125KZT5004100100"
        @test iban(
                CountryCode="KW",
                BankCode="CBKU",
                AccountNumber="0000000000001234560101",
        )["value"] == "KW81CBKU0000000000001234560101"
        @test iban(
                CountryCode="LC",
                BankCode="HEMM",
                AccountNumber="000100010012001200023015",
        )["value"] == "LC55HEMM000100010012001200023015"
        @test iban(
                CountryCode="LV",
                BankCode="BANK",
                AccountNumber="0000435195001",
        )["value"] == "LV80BANK0000435195001"
        @test iban(
                CountryCode="LB",
                BankCode="0999",
                AccountNumber="00000001001901229114",
        )["value"] == "LB62099900000001001901229114"
        @test iban(
                CountryCode="LI",
                BankCode="08810",
                AccountNumber="0002324013AA",
        )["value"] == "LI21088100002324013AA"
        @test iban(
                CountryCode="LT",
                BankCode="10000",
                AccountNumber="11101001000",
        )["value"] == "LT121000011101001000"
        @test iban(
                CountryCode="LU",
                BankCode="001",
                AccountNumber="9400644750000",
        )["value"] == "LU280019400644750000"
        @test iban(
                CountryCode="MK",
                BankCode="250",
                AccountNumber="1200000589",
                NationalCheckDigit="84",
        )["value"] == "MK07250120000058984"
        @test iban(
                CountryCode="MT",
                BankCode="MALT",
                BranchCode="01100",
                AccountNumber="0012345MTLCAST001S",
        )["value"] == "MT84MALT011000012345MTLCAST001S"
        @test iban(
                CountryCode="MR",
                BankCode="00020",
                BranchCode="00101",
                AccountNumber="00001234567",
                NationalCheckDigit="53",
        )["value"] == "MR1300020001010000123456753"
        @test iban(
                CountryCode="MU",
                BankCode="BOMM01",
                BranchCode="01",
                AccountNumber="101030300200000MUR",
        )["value"] == "MU17BOMM0101101030300200000MUR"
        @test iban(
                CountryCode="MD",
                BankCode="AG",
                AccountNumber="000225100013104168",
        )["value"] == "MD24AG000225100013104168"
        @test iban(
                CountryCode="MC",
                BankCode="11222",
                BranchCode="00001",
                AccountNumber="01234567890",
                NationalCheckDigit="30",
        )["value"] == "MC5811222000010123456789030"
        @test iban(
                CountryCode="ME",
                BankCode="505",
                AccountNumber="0000123456789",
                NationalCheckDigit="51",
        )["value"] == "ME25505000012345678951"
        @test iban(
                CountryCode="NL",
                BankCode="ABNA",
                AccountNumber="0417164300",
        )["value"] == "NL91ABNA0417164300"
        @test iban(
                CountryCode="NO",
                BankCode="8601",
                AccountNumber="111794",
                NationalCheckDigit="7",
        )["value"] == "NO9386011117947"
        @test iban(
                CountryCode="PK",
                BankCode="SCBL",
                AccountNumber="0000001123456702",
        )["value"] == "PK36SCBL0000001123456702"
        @test iban(
                CountryCode="PS",
                BankCode="PALS",
                AccountNumber="000000000400123456702",
        )["value"] == "PS92PALS000000000400123456702"
        @test iban(
                CountryCode="PL",
                BankCode="109",
                BranchCode="0101",
                AccountNumber="0000071219812874",
                NationalCheckDigit="4",
        )["value"] == "PL61109010140000071219812874"
        @test iban(
                CountryCode="PT",
                BankCode="0002",
                BranchCode="0123",
                AccountNumber="12345678901",
                NationalCheckDigit="54",
        )["value"] == "PT50000201231234567890154"
        @test iban(
                CountryCode="RO",
                BankCode="AAAA",
                AccountNumber="1B31007593840000",
        )["value"] == "RO49AAAA1B31007593840000"
        @test iban(
                CountryCode="QA",
                BankCode="DOHB",
                AccountNumber="00001234567890ABCDEFG",
        )["value"] == "QA58DOHB00001234567890ABCDEFG"
        @test iban(
                CountryCode="SC",
                BankCode="SSCB",
                BranchCode="1101",
                AccountNumber="0000000000001497",
                AccountType="USD",
        )["value"] == "SC18SSCB11010000000000001497USD"
        @test iban(
                CountryCode="SM",
                BankCode="03225",
                BranchCode="09800",
                AccountNumber="000000270100",
                NationalCheckDigit="U",
        )["value"] == "SM86U0322509800000000270100"
        @test iban(
                CountryCode="ST",
                BankCode="0001",
                BranchCode="0001",
                AccountNumber="0051845310112",
        )["value"] == "ST68000100010051845310112"
        @test iban(
                CountryCode="SA",
                BankCode="80",
                AccountNumber="000000608010167519",
        )["value"] == "SA0380000000608010167519"
        @test iban(
                CountryCode="RS",
                BankCode="260",
                BranchCode="26",
                AccountNumber="0056010016113",
                NationalCheckDigit="79",
        )["value"] == "RS35260005601001611379"
        @test iban(
                CountryCode="SK",
                BankCode="1200",
                AccountNumber="0000198742637541",
        )["value"] == "SK3112000000198742637541"
        @test iban(
                CountryCode="SV",
                BankCode="CENR",
                AccountNumber="00000000000000700025",
        )["value"] == "SV62CENR00000000000000700025"
        @test iban(
                CountryCode="SI",
                BankCode="26",
                BranchCode="330",
                AccountNumber="00120390",
                NationalCheckDigit="86",
        )["value"] == "SI56263300012039086"
        @test iban(
                CountryCode="ES",
                BankCode="2100",
                BranchCode="0418",
                AccountNumber="0200051332",
                NationalCheckDigit="45",
        )["value"] == "ES9121000418450200051332"
        @test iban(
                CountryCode="SE",
                BankCode="500",
                AccountNumber="00000058398257466",
        )["value"] == "SE4550000000058398257466"
        @test iban(
                CountryCode="CH",
                BankCode="00762",
                AccountNumber="011623852957",
        )["value"] == "CH9300762011623852957"
        @test iban(
                CountryCode="TN",
                BankCode="10",
                BranchCode="006",
                AccountNumber="035183598478831",
        )["value"] == "TN5910006035183598478831"
        @test iban(
                CountryCode="TR",
                BankCode="00061",
                AccountNumber="0519786457841326",
                NationalCheckDigit="0",
        )["value"] == "TR330006100519786457841326"
        @test iban(
                CountryCode="AE",
                BankCode="033",
                AccountNumber="1234567890123456",
        )["value"] == "AE070331234567890123456"
        @test iban(
                CountryCode="GB",
                BankCode="NWBK",
                BranchCode="601613",
                AccountNumber="31926819",
        )["value"] == "GB29NWBK60161331926819"
        @test iban(
                CountryCode="VG",
                BankCode="VPVG",
                AccountNumber="0000012345678901",
        )["value"] == "VG96VPVG0000012345678901"
        @test iban(
                CountryCode="TL",
                BankCode="008",
                AccountNumber="00123456789101",
                NationalCheckDigit="57",
        )["value"] == "TL380080012345678910157"
        @test iban(
                CountryCode="XK",
                BankCode="10",
                BranchCode="00",
                AccountNumber="0000000000",
                NationalCheckDigit="53",
        )["value"] == "XK051000000000000053"
        @test iban(
                CountryCode="IR",
                BankCode="017",
                AccountNumber="0000000000123456789",
        )["value"] == "IR200170000000000123456789"
        @test iban(
                CountryCode="FO",
                BankCode="5432",
                AccountNumber="038889994",
                NationalCheckDigit="4",
        )["value"] == "FO9754320388899944"
        @test iban(
                CountryCode="GL",
                BankCode="6471",
                AccountNumber="0001000206",
        )["value"] == "GL8964710001000206"
        @test iban(
                CountryCode="UA",
                BankCode="354347",
                AccountNumber="0006762462054925026",
        )["value"] == "UA573543470006762462054925026"

end
