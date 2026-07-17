Function Get-DCAIPRange
{
	<#
	.SYNOPSIS
		Get Defender Cloud Apps IP ranges.

	.NOTES
		Author: Michal Gajda

	.EXAMPLE
		$BaseUri = https://<tenant>.<region>.portal.cloudappsecurity.com
		$Filters = @{
			category = @{
				eq = 3
			}
		}
		$IPRanges = Get-DCAIPRange -Token $Token -BaseUri $BaseUri -Filters $Filters -Limit 100

	.LINK
		https://learn.microsoft.com/en-us/defender-cloud-apps/api-data-enrichment-list
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
		$Filters,
		[Int]$Skip = 0,
		[Int]$Limit = 10
	)

	Begin
	{
		if(!$MyInvocation.BoundParameters.ContainsKey("Token")) { $Token = $Global:Token }

		$Headers = @{
			'Content-Type' = 'application/json'
			Accept = 'application/json'
			Authorization = "$TokenType $Token"
		}

		$Results = @()
	}

	Process
	{
		$Uri = "$BaseUri/api/v1/subnet/"

		do
		{
			$Body = @{
				"skip" = $Skip
				"limit" = $Limit
			}
			if($Filters) { $Body['filters'] = $Filters }

			$Request = @{
				Method = "GET"
				Uri = $Uri
				Headers = $Headers
				Body = $Body | ConvertTo-Json -Depth 5
				ErrorAction = "Stop"
			}

			Write-Verbose $Uri
			Write-Verbose "$($Body | ConvertTo-Json -Depth 5 -Compress)"
			$Response = Invoke-RestMethod @Request
			if($Response.data)
			{
				$Results += $Response.data
			} else {
				$Results += $Response
			}

			if($Response.hasNext) { $Skip += $Limit }
		}
		while($Response.hasNext)
	}

	End
	{
		Return $Results
	}
}
