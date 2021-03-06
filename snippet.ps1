[System.Collections.ArrayList]$b=@()
$null = get-command | Where-Object source -like 'Microsoft.PowerShell*' | select name | %{$b.add($_.name)}
$null = get-alias | %{ $b.add($_.name) }
[System.Collections.ArrayList]$ArrayOfFunctions=@()
$FolderPath = "C:\Users\Lx\GitPerso\AdsiPS\AdsiPS\Public"

## Find all functions
Get-childitem -path $FolderPath -recurse -include '*.ps1','*.psm1' | %{
    
    $Raw = [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$Null)
    $x=$Raw.FindAll({$args[0] -is [System.Management.Automation.Language.Ast]}, $true)

    # si il ya  une seule fonction dans le fichier
    If ( ($x.where({$_ -is [System.Management.Automation.Language.FunctionDefinitionAST]})).count -eq 1  ) {
        $x.where({$_ -is [System.Management.Automation.Language.FunctionDefinitionAST]}) | select @{l='name';e={($_.name).ToLower()}},@{l="cmdlets";e={($x.findall({$args[0] -is [System.Management.Automation.Language.CommandAst]})).GetCommandName().ToLower() | %{if ( $_ -notin $b.name){$_}}}} | select name,cmdlets,@{l='IsDependent';e={If($null -ne $_.Cmdlets){$True}else{$false}}} | %{$ArrayOfFunctions.add($_)}
    }
}

## Draw Graph
graph depencies @{rankdir='LR'}{
    Foreach ( $t in $ArrayOfFunctions ) {
        If ( $t.IsDependent ) {
                node -Name $t.name -Attributes @{Color='red'}
        } Else {
            node -Name $t.name -Attributes @{Color='green'}
        }
    
        If ( $null -ne $t.cmdlets) {
            Foreach($cmdlet in ($t.cmdlets | select -unique) ) {
                edge -from $t.name -to $cmdlet
            }
        }
    }
} | Show-PSGraph -DestinationPath c:\temp\autobot.pdf -OutputFormat pdf

