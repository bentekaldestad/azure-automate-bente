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
Write-Host "Kortstokk: $(kortstokkprint($cards))"

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
    Write-Output "magnus | $(kortsum -cards $kortStokkMagnus) | $(kortstokkprint -cards $kortStokkMagnus)"    
    Write-Output "meg    | $(kortsum -Cards $kortStokkMeg) | $(kortstokkprint -Cards $kortStokkMeg)"
}


# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if (((kortsum -Cards $meg) -eq $blackjack) -and ((Kortsum -Cards $magnus) -eq $blackjack)) {
    skrivUtResultat -vinner "dawn" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif
((kortsum -Cards $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((Kortsum -Cards $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

while ((Kortsum -Cards $meg) -lt 17) {
    $meg += $cards[0]
    $cards = $cards[1..$cards.Count]
}
if ((Kortsum -Cards $meg) -gt $blackjack) {
    skrivUtResultat -vinner "magnus" $(kortstokkprint($magnus)) $(kortstokkprint($meg))
    exit
}