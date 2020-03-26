# DSC uses the Get-TargetResource function to fetch the status of the resource instance specified in the parameters for the target machine
function Get-TargetResource
{
    param
    (

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present"



    )

        if (test-path -Path $Path) {
        
        Write-Verbose "Current State: Path: $Path, Ensure: Present"
        
            @{
            
                Path = $Path
                Ensure = 'Present'

            } 
            
         } else {
            
        
        Write-Verbose "Current State: Path: $Path, Ensure: Absent"
        
            @{
            
                Path = $Path
                Ensure = 'Absent'
            
            }   
            
         }
        
        
}


function Set-TargetResource
{
    param
    (

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present"



    )
        $TestResult = test-path -Path $Path

        if ($TestResult -and $Ensure -eq 'Absent' -and $path -notin 'c:\','c:','c:\Windows\','c:\Windows','c:\Users','c:\Users\','C:\Program Files','C:\Program Files\','C:\Program Files (x86)','C:\Program Files (x86)\') {
            
            Write-Verbose "Deleting the file $Path."
            Remove-Item -Path $Path -Force        

            
         } else {
            
            Write-Verbose "Nothing to do. FileExist: $TestResult and Ensure: $Ensure, Path = $Path"
            
         }   
            
         
        
        
}

function Test-TargetResource
{
    param
    (

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present"



    )
        $TestResult = test-path -Path $Path

     if ($Ensure -eq 'Present') {
     
     
     
        if ($TestResult -eq $true) {
        
            Write-Verbose "$Path exists and expected to be Present."
            $true
        
        } else {
        
        
            Write-Verbose "$Path does not exist but it is expected to be Present."
            $false
        
        }
     
     
     } else {
     
     
        if ($TestResult -eq $true) {
        
            Write-Verbose "$Path exists and expected to be Absent."
            $false
        
        } else {
        
        
            Write-Verbose "$Path does not exist and it is expected to be absent."
            $true
        
        }
     
     
     
     }

        
}
