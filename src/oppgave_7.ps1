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

#Write-Host "Kortstokk: $(kortstokkprint($cards))"
#Write-Host "Poengsum: $sum"

$meg = $cards[0..3]
$summeg = 0
foreach ($card in $meg) {
    $summeg += switch ($card.value)
    { 
        'J' {10}
        'Q' {10}
        'K' {10}
        'A' {11}
        Default {$card.value}
    }
}

$kortstokk = $cards[4..$cards.Length]
$magnus = $kortstokk[0..3]
$summagnus = 0
foreach ($card in $magnus) {
    $summagnus += switch ($card.value)
   { 
        'J' {10}
        'Q' {10}
        'K' {10}
        'A' {11}
        Default {$card.value}
    }
}

$kortstokk2 = $kortstokk[4..$kortstokk.Length]

#Write-Host "meg: $(kortstokkprint($meg))"
#Write-Output "sum meg: $summeg"
#Write-Host "Magnus: $(kortstokkprint($magnus))"
#Write-Output "Sum Magnus: $summagnus"
#Write-Host "Kortstokk: $(kortstokkprint($kortstokk2))"


# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if (($summeg) -eq $blackjack) {
    Write-Output "meg | $meg | $summeg" 
    exit
}
elseif (($summagnus) -eq $blackjack) {
    Write-Output "Magnus | $magnus | $summagnus" 
    exit
}
else {
    Write-Host "Ingen vinner"
    exit
}
