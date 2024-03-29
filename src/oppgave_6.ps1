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
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-Host "meg: $(kortstokkprint($meg))"
Write-Host "Magnus: $(kortstokkprint($magnus))"
Write-Host "Kortstokk: $(kortstokkprint($cards))"