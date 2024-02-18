Config = {

    -- Do not change anything else but values unless you know what you are doing!

    PlateCost = 150, -- How much it costs to change licenseplate

    PlateCheckCost = 100, -- How much it costs to check licenseplates

    Blip = {
        Enabled = true,
        Sprite = 764,
        Color = 26,
        Scale = 1.0,
    },

    MinLength = 8, -- What is the minimum length for the plate? Do not go higher than 8. It will break stuff

    PlateStations = {
        vec3(1145.0, -780.0, 58.0), --has support for multiple stations
    },

    Strings = {

        Blip = "Change licenseplate",

        PlateMenu = "Change licenseplate",

        ChangePlateMenu = "Change the licenseplate of your vehicle (Costs %s$ + additional %s$ for checking the availability)",
        CheckPlateMenu = "Check licenseplate availability (Costs %s$)",

        SpecialChars = "You cant have any special characters!",
        SpecialCharsDesc = "Having them in your licenseplate breaks stuff.",

        WritePlateText = "Write your text here!",

        PlateNotTaken = "This plate was not taken!",
        PlateNotTakenDesc = "This means that you can use it in your vehicle!",

        PlateTaken = "This plate was taken!",
        PlateTakenDesc = "This means that you cant use it in your vehicle!",

        TooShortPlate = "Provided plate was too small!",
        TooShortPlateDesc = "Plate must be atleast %s characters long.",

        NoVeh = "You are not in any vehicle!",
        NoVehDescription = "What plate are you trying to change, huh?",

        NoMoney = "You dont have enough money!",
        NoMoneyDesc = "You are %s$ short!",

        ChargedForChanging = "You have been charged!",
        ChargedForChangingDesc = "You have been charged %s$ for changing the plate.",

        ChargedForChecking = "You have been charged!",
        ChargedForCheckingDesc = "You have been charged %s$ for checking availability!",
    }
}
