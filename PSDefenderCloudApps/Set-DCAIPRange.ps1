Function Set-DCAIPRange
{
	<#
	.SYNOPSIS
		Set Defender Cloud Apps IP range.

	.NOTES
		Author: Michal Gajda

	.EXAMPLE
		$BaseUri = https://<tenant>.<region>.portal.cloudappsecurity.com
		$IPRanges = Set-DCAIPRange -Token $Token -BaseUri $BaseUri -IPRangeId "12345" -Name "My IP Range" -Category "Corporate" -Subnets @("192.168.1.0/24")

	.LINK
		https://learn.microsoft.com/en-us/defender-cloud-apps/api-data-enrichment-update
	#>
	[CmdletBinding(DefaultParameterSetName = "All")]
	Param
	(
		[Parameter(Mandatory = $true)]
		[String]$Token,
		[ValidateSet("Bearer","Token")]
		[String]$TokenType = "Bearer",
		[Parameter(Mandatory = $true)]
		$BaseUri,
		[Parameter(Mandatory = $true)]
		[String]$IPRangeId,
		[Parameter(Mandatory = $true)]
		[String]$Name,
		[Parameter(Mandatory = $true)]
		[ValidateSet("Corporate","Administrative","Risky","VPN","CloudProvider","Other")]
		[String]$Category,
		[Parameter(Mandatory = $true)]
		[String[]]$Subnets,
		[String[]]$Tags,
		[String]$Organization
	)

	Begin
	{
		if(!$MyInvocation.BoundParameters.ContainsKey("Token")) { $Token = $Global:Token }

		$Headers = @{
			'Content-Type' = 'application/json'
			Accept = 'application/json'
			Authorization = "$TokenType $Token"
		}

		$CategoryValue = @{
			"Corporate" = 1
			"Administrative" = 2
			"Risky" = 3
			"VPN" = 4
			"CloudProvider" = 5
			"Other" = 6
		}
		$Results = @()
	}

	Process
	{
		$Uri = "$BaseUri/api/v1/subnet/$IPRangeId/update_rule/"

		$Body = @{
			name = $Name
			category = $CategoryValue[$Category]
			subnets = $Subnets
		}
		if($Tags) { $Body['tags'] = $Tags }
		if($Organization) { $Body['organization'] = $Organization }

		$Request = @{
			Method = "POST"
			Uri = $Uri
			Headers = $Headers
			Body = $Body | ConvertTo-Json -Depth 5
			ErrorAction = "Stop"
		}

		Write-Verbose $Uri
		Write-Verbose "$($Body | ConvertTo-Json -Depth 5 -Compress)"
		$Response = Invoke-RestMethod @Request
	}

	End
	{
		Return $Response
	}
}
