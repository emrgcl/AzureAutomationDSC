[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    [Parameter(Mandatory=$true)]
    [string]$AutomationAccountName,
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory=$true)]
    $Value

)
$Context = Get-AZContext
if (!$Context) {
    
    try {
        Connect-AzAccount -ErrorAction Stop    
    }
    catch {
        Throw $_
    }

    
    Write-Verbose "Connecting to Azure. " 

} else {

    Write-Verbose "Already connected to $($Context.SubscriptionName). Account: $($Context.Account)"

}

try {
    Get-AZAutomationVariable -AutomationAccountName $AutomationAccountName -ResourceGroupName $ResourceGroupName -Name $Name -ErrorAction Stop | Out-Null
    Set-AzAutomationVariable -AutomationAccountName $AutomationAccountName -ResourceGroupName $ResourceGroupName -Name $Name -Encrypted $False -Value $Value | Out-Null
}
catch [ResourceNotFoundException] {
    Write-Verbose "Variable named $Name could not be found adding new one."
    New-AzAutomationVariable -AutomationAccountName $AutomationAccountName -ResourceGroupName $ResourceGroupName -Name $Name -Encrypted $False -Value $Value
}
Catch{
    throw $_
}
finally {
    
}