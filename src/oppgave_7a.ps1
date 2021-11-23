[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'
$response = Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.Content| ConvertFrom-Json

$sum = 0
foreach ($card in $cards) {
    $sum += switch ($card.value)
    { 
        'J' {10}
        'Q' {10}
        'K' {10}
        'A' {11}
        Default {$card.value}
    }
}

function kortstokkprint {
    param (
    [Parameter()]
    [Object[]]
        $cards
    )
    $kortstokk = @()
    foreach ($card in $cards) {
    $kortstokk += ($card.suit[0] + $card.value)
    }

# Skriver ut kortstokk
$kortstokk = @()
foreach ($card in $cards) {
    $kortstokk += ($card.suit[0] + $card.value)
    }
    $kortstokk
}

Write-Host "Kortstokk: $(kortstokkprint($cards))"
Write-Host "Poengsum: $sum"

$meg = $cards[0..1]
$kortstokk = $cards[2..$cards.Length]
$magnus = $kortstokk[0..1]
$kortstokk2 = $kortstokk[2..$kortstokk.Length]

Write-Host "meg: $(kortstokkprint($meg))"
Write-Host "Magnus: $(kortstokkprint($magnus))"
Write-Host "Kortstokk: $(kortstokkprint($kortstokk2))"


function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk <#?#>) | $(<#?#> -kortstokk $kortStokkMagnus)"    
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk <#?#>) | $(<#?#> -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner <#?#> -kortStokkMagnus <#?#> -kortStokkMeg <#?#>
    exit
}
elseif ((sumPoengKortstokk -kortstokk <#?#>) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus <#?#> -kortStokkMeg <#?#>
    exit
}

# Hva er om begge har blackjack? Kanskje det kalles draw?
# frivillig - kan du endre koden til å ta hensyn til draw?