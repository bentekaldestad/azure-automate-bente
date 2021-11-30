[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'
$response = Invoke-WebRequest -Uri $UrlKortstokk

$cards = $response.Content| ConvertFrom-Json

function Kortsum {
    param ( 
    [Parameter()]
    [Object[]]
        $Cards
    ) 
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
    $sum
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
$sumkortstokk=kortsum($cards)
Write-Host "Poengsum: $sumkortstokk"

$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-Host "meg: $(kortstokkprint($meg))"
Write-Host "Magnus: $(kortstokkprint($magnus))"
#Write-Host "Kortstokk: $(kortstokkprint($cards))"


# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

$summeg = kortsum($meg)
$summagnus = kortsum($magnus)
Write-Host "sum meg $summeg"
Write-Host "sum magnus $summagnus"

if ($summeg -eq $blackjack -and $summagnus -eq $blackjack){
    Write-Output "Dawn"
 }
elseif (($summeg) -eq $blackjack) {
    Write-Output "Vinner: meg | $(kortstokkprint($meg)) | $summeg" 
    exit
}
elseif (($summagnus) -eq $blackjack) {
    Write-Output "Vinner: Magnus | $(kortstokkprint($magnus)) | $summagnus" 
    exit
}
else {
    Write-Host "Ingen vinner"
    exit
}