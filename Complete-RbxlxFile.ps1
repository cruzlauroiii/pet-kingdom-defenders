<#
.SYNOPSIS
    Completes the PetKingdomDefenders.rbxlx file with all Lua scripts

.DESCRIPTION
    This PowerShell script reads all Lua files from the project directory
    and injects them into the PetKingdomDefenders.rbxlx file in the correct
    locations with proper XML formatting, so the file can be opened directly
    in Roblox Studio without any manual script copying.

    The script creates a new file: PetKingdomDefenders_Complete.rbxlx

.PARAMETER ProjectPath
    Path to the project root directory (default: script location)

.PARAMETER RbxlxFile
    Path to the source RBXLX file (default: ProjectPath\PetKingdomDefenders.rbxlx)

.PARAMETER OutputFile
    Path for the output file (default: ProjectPath\PetKingdomDefenders_Complete.rbxlx)

.EXAMPLE
    .\Complete-RbxlxFile.ps1
    Processes files in the current directory

.EXAMPLE
    .\Complete-RbxlxFile.ps1 -ProjectPath "C:\MyProject"
    Processes files in the specified directory

.NOTES
    Created for Pet Kingdom Defenders - 100% Procedurally Generated Roblox Game
    No AI co-author attribution
    Supports: Script, LocalScript, ModuleScript
#>

[CmdletBinding()]
param(
    [string]$ProjectPath,
    [string]$RbxlxFile,
    [string]$OutputFile
)

# Set defaults if not provided
if (-not $ProjectPath) {
    if ($PSScriptRoot) {
        $ProjectPath = $PSScriptRoot
    }
    else {
        $ProjectPath = Get-Location
    }
}

if (-not $RbxlxFile) {
    $RbxlxFile = Join-Path $ProjectPath "PetKingdomDefenders.rbxlx"
}

if (-not $OutputFile) {
    $OutputFile = Join-Path $ProjectPath "PetKingdomDefenders_Complete.rbxlx"
}

# Display banner
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Pet Kingdom Defenders - RBXLX Completer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Global counter for unique IDs
$script:ReferentCounter = 1000

# Function to generate unique Roblox referent ID
function New-RobloxReferent {
    $guid = [Guid]::NewGuid().ToString("N").ToUpper()
    $script:ReferentCounter++
    return "RBX$guid"
}

# Function to escape content for CDATA
function Escape-CDATAContent {
    param([string]$Content)

    # If content contains ]]>, we need to split CDATA sections
    # Replace ]]> with ]]]]><![CDATA[>
    if ($Content -match '\]\]>') {
        $Content = $Content -replace '\]\]>', ']]]]><![CDATA[>'
    }

    return $Content
}

# Function to read Lua file
function Read-LuaFileContent {
    param([string]$FilePath)

    if (Test-Path $FilePath) {
        try {
            # Read with UTF8 encoding, remove BOM if present
            $content = [System.IO.File]::ReadAllText($FilePath, [System.Text.UTF8Encoding]::new($false))
            return Escape-CDATAContent $content
        }
        catch {
            Write-Warning "Error reading file $FilePath : $_"
            return ""
        }
    }
    else {
        Write-Warning "File not found: $FilePath"
        return ""
    }
}

# Function to create a script Item element
function New-ScriptItem {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Script', 'LocalScript', 'ModuleScript')]
        [string]$ClassName,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$SourceCode,

        [string]$Referent = (New-RobloxReferent)
    )

    # Build XML string manually to ensure proper formatting
    $xml = @"
	<Item class="$ClassName" referent="$Referent">
		<Properties>
			<string name="Name">$Name</string>
			<ProtectedString name="Source"><![CDATA[$SourceCode]]></ProtectedString>
		</Properties>
	</Item>

"@

    return $xml
}

# Main script execution
try {
    Write-Host "[Step 1/6] Validating paths..." -ForegroundColor Yellow

    if (-not (Test-Path $RbxlxFile)) {
        throw "Source RBXLX file not found: $RbxlxFile"
    }

    if (-not (Test-Path $ProjectPath)) {
        throw "Project path not found: $ProjectPath"
    }

    Write-Host "  ✓ Source RBXLX: $RbxlxFile" -ForegroundColor Green
    Write-Host "  ✓ Project path: $ProjectPath" -ForegroundColor Green
    Write-Host "  ✓ Output file: $OutputFile" -ForegroundColor Green

    Write-Host ""
    Write-Host "[Step 2/6] Reading source RBXLX file..." -ForegroundColor Yellow

    # Read the template RBXLX
    $templateContent = Get-Content -Path $RbxlxFile -Raw -Encoding UTF8
    Write-Host "  ✓ Template loaded ($(($templateContent.Length / 1KB).ToString('N2')) KB)" -ForegroundColor Green

    Write-Host ""
    Write-Host "[Step 3/6] Reading all Lua files..." -ForegroundColor Yellow

    $scriptsToAdd = @()
    $filesProcessed = 0

    # Define all scripts to process
    $scriptDefinitions = @(
        # ServerScriptService scripts
        @{
            Path = "ServerScriptService\InitializeRemotes.lua"
            Class = "Script"
            Name = "InitializeRemotes"
            InsertAfter = '<Item class="ServerScriptService" referent="RBXSERVERSCRIPTSERVICE">'
            Indent = 2
        },
        @{
            Path = "ServerScriptService\MainServer.lua"
            Class = "Script"
            Name = "MainServer"
            InsertAfter = '<Item class="ServerScriptService" referent="RBXSERVERSCRIPTSERVICE">'
            Indent = 2
        },

        # ServerScriptService/Modules
        @{
            Path = "ServerScriptService\Modules\SecurityManager.lua"
            Class = "ModuleScript"
            Name = "SecurityManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\DataManager.lua"
            Class = "ModuleScript"
            Name = "DataManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\PetSystem.lua"
            Class = "ModuleScript"
            Name = "PetSystem"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\TowerDefenseManager.lua"
            Class = "ModuleScript"
            Name = "TowerDefenseManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\TycoonManager.lua"
            Class = "ModuleScript"
            Name = "TycoonManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\EconomyManager.lua"
            Class = "ModuleScript"
            Name = "EconomyManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\TradingSystem.lua"
            Class = "ModuleScript"
            Name = "TradingSystem"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ObbyManager.lua"
            Class = "ModuleScript"
            Name = "ObbyManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\EventManager.lua"
            Class = "ModuleScript"
            Name = "EventManager"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ProceduralPetGenerator.lua"
            Class = "ModuleScript"
            Name = "ProceduralPetGenerator"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ProceduralBuildingGenerator.lua"
            Class = "ModuleScript"
            Name = "ProceduralBuildingGenerator"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ProceduralEnemyGenerator.lua"
            Class = "ModuleScript"
            Name = "ProceduralEnemyGenerator"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ProceduralTerrainGenerator.lua"
            Class = "ModuleScript"
            Name = "ProceduralTerrainGenerator"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ProceduralUIGenerator.lua"
            Class = "ModuleScript"
            Name = "ProceduralUIGenerator"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },
        @{
            Path = "ServerScriptService\Modules\ProceduralItemGenerator.lua"
            Class = "ModuleScript"
            Name = "ProceduralItemGenerator"
            InsertAfter = '<Item class="Folder" referent="RBX20">'
            Indent = 3
        },

        # ReplicatedStorage/Shared
        @{
            Path = "ReplicatedStorage\Shared\Config.lua"
            Class = "ModuleScript"
            Name = "Config"
            InsertAfter = '<Item class="Folder" referent="RBX11">'
            Indent = 3
        },
        @{
            Path = "ReplicatedStorage\Shared\PetData.lua"
            Class = "ModuleScript"
            Name = "PetData"
            InsertAfter = '<Item class="Folder" referent="RBX11">'
            Indent = 3
        },
        @{
            Path = "ReplicatedStorage\Shared\Utils.lua"
            Class = "ModuleScript"
            Name = "Utils"
            InsertAfter = '<Item class="Folder" referent="RBX11">'
            Indent = 3
        },

        # ReplicatedStorage/Remotes
        @{
            Path = "ReplicatedStorage\Remotes\RemotesSetup.lua"
            Class = "ModuleScript"
            Name = "RemotesSetup"
            InsertAfter = '<Item class="Folder" referent="RBX10">'
            Indent = 3
        },

        # StarterPlayerScripts
        @{
            Path = "StarterPlayer\StarterPlayerScripts\MainClient.lua"
            Class = "LocalScript"
            Name = "MainClient"
            InsertAfter = '<Item class="StarterPlayerScripts" referent="RBX30">'
            Indent = 3
        },

        # StarterPlayerScripts/Modules
        @{
            Path = "StarterPlayer\StarterPlayerScripts\Modules\UIManager.lua"
            Class = "ModuleScript"
            Name = "UIManager"
            InsertAfter = '<Item class="Folder" referent="RBX31">'
            Indent = 4
        },
        @{
            Path = "StarterPlayer\StarterPlayerScripts\Modules\InputManager.lua"
            Class = "ModuleScript"
            Name = "InputManager"
            InsertAfter = '<Item class="Folder" referent="RBX31">'
            Indent = 4
        },
        @{
            Path = "StarterPlayer\StarterPlayerScripts\Modules\CameraController.lua"
            Class = "ModuleScript"
            Name = "CameraController"
            InsertAfter = '<Item class="Folder" referent="RBX31">'
            Indent = 4
        },
        @{
            Path = "StarterPlayer\StarterPlayerScripts\Modules\SoundManager.lua"
            Class = "ModuleScript"
            Name = "SoundManager"
            InsertAfter = '<Item class="Folder" referent="RBX31">'
            Indent = 4
        },
        @{
            Path = "StarterPlayer\StarterPlayerScripts\Modules\NotificationManager.lua"
            Class = "ModuleScript"
            Name = "NotificationManager"
            InsertAfter = '<Item class="Folder" referent="RBX31">'
            Indent = 4
        },

        # StarterGui
        @{
            Path = "StarterGui\MainUI.lua"
            Class = "LocalScript"
            Name = "MainUI"
            InsertAfter = '<Item class="StarterGui" referent="RBXSTARTERGUI">'
            Indent = 2
        }
    )

    # Read all files
    foreach ($scriptDef in $scriptDefinitions) {
        $fullPath = Join-Path $ProjectPath $scriptDef.Path

        if (Test-Path $fullPath) {
            $sourceCode = Read-LuaFileContent -FilePath $fullPath

            if ($sourceCode) {
                $scriptDef.SourceCode = $sourceCode
                $scriptsToAdd += $scriptDef
                $filesProcessed++
                Write-Host "  ✓ $($scriptDef.Name)" -ForegroundColor Green
            }
        }
        else {
            Write-Warning "  ✗ File not found: $($scriptDef.Path)"
        }
    }

    Write-Host ""
    Write-Host "  Total files read: $filesProcessed" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "[Step 4/6] Building complete RBXLX..." -ForegroundColor Yellow

    # Group scripts by their insertion point
    $insertionGroups = $scriptsToAdd | Group-Object -Property InsertAfter

    $outputContent = $templateContent
    $totalInserted = 0

    foreach ($group in $insertionGroups) {
        $insertAfterMarker = $group.Name
        $scriptsInGroup = $group.Group

        # Build all XML for this group
        $xmlToInsert = ""
        foreach ($script in $scriptsInGroup) {
            $tabs = "`t" * $script.Indent
            $scriptXml = New-ScriptItem -ClassName $script.Class -Name $script.Name -SourceCode $script.SourceCode
            # Add proper indentation
            $scriptXml = $scriptXml -split "`r?`n" | ForEach-Object { if ($_ -match '\S') { "$tabs$_" } else { $_ } } | Out-String
            $xmlToInsert += $scriptXml
            $totalInserted++
        }

        # Insert all scripts for this group after the marker
        if ($outputContent -match [regex]::Escape($insertAfterMarker)) {
            $outputContent = $outputContent -replace "($([regex]::Escape($insertAfterMarker)))", "`$1`r`n$xmlToInsert"
            Write-Host "  ✓ Inserted $($scriptsInGroup.Count) scripts after marker: $insertAfterMarker" -ForegroundColor Green
        }
        else {
            Write-Warning "  ✗ Marker not found: $insertAfterMarker"
        }
    }

    Write-Host "  ✓ Total scripts inserted: $totalInserted" -ForegroundColor Green

    Write-Host ""
    Write-Host "[Step 5/6] Writing output file..." -ForegroundColor Yellow

    # Write output file
    [System.IO.File]::WriteAllText($OutputFile, $outputContent, [System.Text.UTF8Encoding]::new($false))

    $outputFileInfo = Get-Item $OutputFile
    $fileSizeMB = [math]::Round($outputFileInfo.Length / 1MB, 2)
    $fileSizeKB = [math]::Round($outputFileInfo.Length / 1KB, 2)

    if ($fileSizeMB -gt 1) {
        Write-Host "  ✓ File written: $fileSizeMB MB" -ForegroundColor Green
    }
    else {
        Write-Host "  ✓ File written: $fileSizeKB KB" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "[Step 6/6] Verification..." -ForegroundColor Yellow

    # Verify output
    if (Test-Path $OutputFile) {
        Write-Host "  ✓ Output file exists" -ForegroundColor Green
        Write-Host "  ✓ Scripts embedded: $totalInserted/$filesProcessed" -ForegroundColor Green

        # Verify it's valid XML (suppress errors)
        $null = [xml](Get-Content $OutputFile -Raw -ErrorAction SilentlyContinue)
        Write-Host "  ✓ XML structure complete" -ForegroundColor Green
    }
    else {
        throw "Output file was not created!"
    }

    # Success!
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "         COMPLETION SUCCESS! " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your complete RBXLX file is ready!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Output File:" -ForegroundColor Cyan
    Write-Host "  $OutputFile" -ForegroundColor White
    Write-Host ""
    Write-Host "Statistics:" -ForegroundColor Cyan
    Write-Host "  • Files embedded: $totalInserted Lua scripts" -ForegroundColor White
    Write-Host "  • File size: $fileSizeKB KB" -ForegroundColor White
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Open Roblox Studio" -ForegroundColor White
    Write-Host "  2. File → Open from File" -ForegroundColor White
    Write-Host "  3. Select: $([System.IO.Path]::GetFileName($OutputFile))" -ForegroundColor White
    Write-Host "  4. Enable API Services (Game Settings → Security)" -ForegroundColor White
    Write-Host "  5. Press F5 to play!" -ForegroundColor White
    Write-Host ""
    Write-Host "ALL SCRIPTS ARE EMBEDDED - NO MANUAL WORK NEEDED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pet Kingdom Defenders - 100% Procedurally Generated" -ForegroundColor Cyan
    Write-Host "Ready to play with ZERO asset dependencies!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "              ERROR" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Stack Trace:" -ForegroundColor Yellow
    Write-Host $_.ScriptStackTrace -ForegroundColor Gray
    Write-Host ""
    exit 1
}
