<center><a href="https://otterkring.github.io/MainPage" style="font-size:75%;">return to MainPage</a></center>

# PS_Expand-IPRange

## Calculate all ip addresses for a given IP range

### Why ...

You may want to create automation or monitoring scripts for all currently connected machines in your network. Using this function you can easily prepare a list of ip addresses to be checked.

#### Example:

You want to run a port scan on all machines in your network, e.g. using [Patrick Gruenauer's Test-OpenPort.ps1](https://www.powershellgallery.com/packages/Test-OpenPort), and your network range is `10.0.0.0/24 (10.0.0.0, Subnet 255.255.255.0)`:

    Expand-IPRange -IPRange '10.0.0.0/24' `
    | foreach ( Test-OpenPort -Target $_ -Port 80,443 )

or with more IP ranges and an array:

    $IPs = '10.0.0.0/24','192.168.0.0/27' | Expand-IPRange
    Test-OpenPort -Target $IPs -Port 80,443


Have fun and happy coding!
Max