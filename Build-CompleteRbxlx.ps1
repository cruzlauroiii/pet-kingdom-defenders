# Build-CompleteRbxlx.ps1
# Creates a complete RBXLX file with all Lua scripts embedded
# Pet Kingdom Defenders - 100% Procedurally Generated

param(
    [string]$OutputFile = "PetKingdomDefenders_Complete.rbxlx"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host "  Pet Kingdom Defenders RBXLX Builder"  -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }
$OutputPath = Join-Path $ScriptDir $OutputFile

Write-Host "[1/4] Loading template..." -ForegroundColor Yellow
$templatePath = Join-Path $ScriptDir "PetKingdomDefenders.rbxlx"

if (-not (Test-Path $templatePath)) {
    throw "Template not found: $templatePath"
}

$xmlContent = [System.IO.File]::ReadAllText($templatePath, [System.Text.UTF8Encoding]::new($false))
Write-Host "  OK - Template loaded" -ForegroundColor Green

Write-Host ""
Write-Host "[2/4] Reading Lua files..." -ForegroundColor Yellow

# Define all script files to embed
$scripts = @(
    @{File="ServerScriptService\InitializeRemotes.lua"; Class="Script"; Name="InitializeRemotes"; Parent="ServerScriptService"},
    @{File="ServerScriptService\MainServer.lua"; Class="Script"; Name="MainServer"; Parent="ServerScriptService"},
    @{File="ServerScriptService\Modules\SecurityManager.lua"; Class="ModuleScript"; Name="SecurityManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\DataManager.lua"; Class="ModuleScript"; Name="DataManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\PetSystem.lua"; Class="ModuleScript"; Name="PetSystem"; Parent="Modules"},
    @{File="ServerScriptService\Modules\TowerDefenseManager.lua"; Class="ModuleScript"; Name="TowerDefenseManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\TycoonManager.lua"; Class="ModuleScript"; Name="TycoonManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\EconomyManager.lua"; Class="ModuleScript"; Name="EconomyManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\TradingSystem.lua"; Class="ModuleScript"; Name="TradingSystem"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ObbyManager.lua"; Class="ModuleScript"; Name="ObbyManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\EventManager.lua"; Class="ModuleScript"; Name="EventManager"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ProceduralPetGenerator.lua"; Class="ModuleScript"; Name="ProceduralPetGenerator"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ProceduralBuildingGenerator.lua"; Class="ModuleScript"; Name="ProceduralBuildingGenerator"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ProceduralEnemyGenerator.lua"; Class="ModuleScript"; Name="ProceduralEnemyGenerator"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ProceduralTerrainGenerator.lua"; Class="ModuleScript"; Name="ProceduralTerrainGenerator"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ProceduralUIGenerator.lua"; Class="ModuleScript"; Name="ProceduralUIGenerator"; Parent="Modules"},
    @{File="ServerScriptService\Modules\ProceduralItemGenerator.lua"; Class="ModuleScript"; Name="ProceduralItemGenerator"; Parent="Modules"},
    @{File="ReplicatedStorage\Shared\Config.lua"; Class="ModuleScript"; Name="Config"; Parent="Shared"},
    @{File="ReplicatedStorage\Shared\PetData.lua"; Class="ModuleScript"; Name="PetData"; Parent="Shared"},
    @{File="ReplicatedStorage\Shared\Utils.lua"; Class="ModuleScript"; Name="Utils"; Parent="Shared"},
    @{File="ReplicatedStorage\Remotes\RemotesSetup.lua"; Class="ModuleScript"; Name="RemotesSetup"; Parent="Remotes"},
    @{File="StarterPlayer\StarterPlayerScripts\MainClient.lua"; Class="LocalScript"; Name="MainClient"; Parent="StarterPlayerScripts"},
    @{File="StarterPlayer\StarterPlayerScripts\Modules\UIManager.lua"; Class="ModuleScript"; Name="UIManager"; Parent="ClientModules"},
    @{File="StarterPlayer\StarterPlayerScripts\Modules\InputManager.lua"; Class="ModuleScript"; Name="InputManager"; Parent="ClientModules"},
    @{File="StarterPlayer\StarterPlayerScripts\Modules\CameraController.lua"; Class="ModuleScript"; Name="CameraController"; Parent="ClientModules"},
    @{File="StarterPlayer\StarterPlayerScripts\Modules\SoundManager.lua"; Class="ModuleScript"; Name="SoundManager"; Parent="ClientModules"},
    @{File="StarterPlayer\StarterPlayerScripts\Modules\NotificationManager.lua"; Class="ModuleScript"; Name="NotificationManager"; Parent="ClientModules"},
    @{File="StarterGui\MainUI.lua"; Class="LocalScript"; Name="MainUI"; Parent="StarterGui"}
)

$loadedScripts = @()
$counter = 0

foreach ($script in $scripts) {
    $filePath = Join-Path $ScriptDir $script.File

    if (Test-Path $filePath) {
        $sourceCode = [System.IO.File]::ReadAllText($filePath, [System.Text.UTF8Encoding]::new($false))

        # Escape CDATA if needed
        if ($sourceCode -match '\]\]>') {
            $sourceCode = $sourceCode -replace '\]\]>', ']]]]><![CDATA[>'
        }

        $script.Source = $sourceCode
        $loadedScripts += $script
        $counter++
        Write-Host "  OK - $($script.Name)" -ForegroundColor Green
    } else {
        Write-Warning "  SKIP - File not found: $($script.File)"
    }
}

Write-Host ""
Write-Host "  Total loaded: $counter/28" -ForegroundColor Cyan

Write-Host ""
Write-Host "[3/4] Building XML..." -ForegroundColor Yellow

# Build script XML elements
$guidCounter = 1000

foreach ($script in $loadedScripts) {
    $guid = [Guid]::NewGuid().ToString("N").ToUpper()
    $referent = "RBX$guid"

    $scriptXml = @"

	<Item class="$($script.Class)" referent="$referent">
		<Properties>
			<string name="Name">$($script.Name)</string>
			<ProtectedString name="Source"><![CDATA[$($script.Source)]]></ProtectedString>
		</Properties>
	</Item>
"@

    # Insert based on parent
    switch ($script.Parent) {
        "ServerScriptService" {
            $marker = '<Item class="Folder" referent="RBX20">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
        "Modules" {
            $marker = '<Item class="Folder" referent="RBX20">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
        "Shared" {
            $marker = '<Item class="Folder" referent="RBX11">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
        "Remotes" {
            $marker = '<Item class="Folder" referent="RBX10">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
        "StarterPlayerScripts" {
            $marker = '<Item class="Folder" referent="RBX31">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
        "ClientModules" {
            $marker = '<Item class="Folder" referent="RBX31">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
        "StarterGui" {
            $marker = '<Item class="StarterGui" referent="RBXSTARTERGUI">'
            $xmlContent = $xmlContent -replace "($([regex]::Escape($marker)))", "`$1$scriptXml"
        }
    }
}

Write-Host "  OK - XML built" -ForegroundColor Green

Write-Host ""
Write-Host "[4/4] Writing output..." -ForegroundColor Yellow

[System.IO.File]::WriteAllText($OutputPath, $xmlContent, [System.Text.UTF8Encoding]::new($false))

$fileSize = (Get-Item $OutputPath).Length
$fileSizeKB = [math]::Round($fileSize / 1KB, 2)

Write-Host "  OK - File written: $fileSizeKB KB" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           SUCCESS!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output: $OutputFile" -ForegroundColor White
Write-Host "Size: $fileSizeKB KB" -ForegroundColor White
Write-Host "Scripts: $counter embedded" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Open Roblox Studio" -ForegroundColor White
Write-Host "  2. File -> Open from File" -ForegroundColor White
Write-Host "  3. Select $OutputFile" -ForegroundColor White
Write-Host "  4. Press F5 to play!" -ForegroundColor White
Write-Host ""
