<#
.SYNOPSIS
Calculate IP addresses from a CIDR range

.DESCRIPTION
Expand-IPRange is an advanced pipeline enabled function for calculating all IP addresses in a given range using CIDR notation

.PARAMETER IPRange
An IP range in CIDR notation, like "10.0.0.0/24", or "192.168.0.0/30"

.EXAMPLE
Expand-IPRange -IPRange '10.0.0.0/30'

Result:
10.0.0.1
10.0.0.2

.EXAMPLE
'10.0.0.0/30','192.168.2.0/29' | Expand-IPRange

Result:
10.0.0.1
10.0.0.2
192.168.2.1
192.168.2.2
192.168.2.3
192.168.2.4
192.168.2.5
192.168.2.6
.NOTES
Maximilian Otter, 08.08.2019 [Twitter:Otterkring]
#>

function Expand-IPRange {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidatePattern('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/(?:3[0-2]|[1-2]?[0-9])$')]     # validation if the provided iprange is plausible
                          #|----------------------1st to 3rd octet ---------|--------------4th octet----------------|-----Bitmask----------|
        [string]$IPRange
    )
    
    begin {

        # Set constants we need for calculations later and don't want to waste time calculating them every time
        $32Bit  = 4294967296
        $8Bit   = 256

    }

    process {

        $SubnetParts = $IPRange -split '/'              # split IPRange in Base IP and Bitmask
        $IPOctets = $SubnetParts[0] -split '\.'         # split IPRange in Octets
        $IPCount = ($32Bit -shr $SubnetParts[1]) - 2    # calculate amount of addresses we will get, excluding base and broadcast address

        # calculate the integer value of the ip address from the octets
        # first octet must be shifted left 24 bits, second 16 bits, third 8 bits, forth stays as is; add them up 
        $IPBase = $IPint = ([uint32]$IPOctets[0] -shl 24) + ([uint32]$IPOctets[1] -shl 16) + ([uint32]$IPOctets[2] -shl 8) + [uint32]$IPOctets[3]

        do {    # until we have all addresses, increment IP value and return IP address
            
            $IPint++

            # first octet:  value shiftet right by 24 bits
            # second octet: value shfitet right by 16 bits, modulo 256
            # third octet:  value shiftet right by 8 bits, modulo 256
            # forth octet:  value modulo 256
            # convert all to string and glue together with dots
            [string]($IPint -shr 24) + '.' + [string](($IPint -shr 16) % $8Bit) + '.' + [string](($IPint -shr 8) % $8Bit) + '.' + [string]($IPint % $8Bit)

        } until ($IPint - $IPBase -eq $IPCount)

    }

    end {
        # nothing yet
    }

}