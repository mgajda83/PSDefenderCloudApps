Function Remove-DCAIPRange
{
	<#
	.SYNOPSIS
		Remove Defender Cloud Apps IP range.

	.NOTES
		Author: Michal Gajda

	.EXAMPLE
		$BaseUri = https://<tenant>.<region>.portal.cloudappsecurity.com
		$IPRanges = Remove-DCAIPRange -Token $Token -BaseUri $BaseUri -IPRangeId "12345"

	.LINK
		https://learn.microsoft.com/en-us/defender-cloud-apps/api-data-enrichment-delete
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
		[String]$IPRangeId
	)

	Begin
	{
		if(!$MyInvocation.BoundParameters.ContainsKey("Token")) { $Token = $Global:Token }

		$Headers = @{
			'Content-Type' = 'application/json'
			Accept = 'application/json'
			Authorization = "$TokenType $Token"
		}
	}

	Process
	{
		$Uri = "$BaseUri/api/v1/subnet/$IPRangeId/"

		$Request = @{
			Method = "DELETE"
			Uri = $Uri
			Headers = $Headers
			ErrorAction = "Stop"
		}

		Write-Verbose $Uri
		$Response = Invoke-RestMethod @Request
	}

	End
	{
		Return $Response
	}
}
