param(
    [string]$RepoRoot = (Split-Path -Parent $PSCommandPath)
)

$ErrorActionPreference = 'Stop'

function Get-YamlFrontMatter {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $null }
    $content = Get-Content -Path $Path -Raw
    # Find first YAML front matter block delimited by --- ... --- anywhere in file
    $startIdx = $content.IndexOf("---")
    if ($startIdx -lt 0) { return $null }
    $rest = $content.Substring($startIdx + 3)
    $endIdx = $rest.IndexOf("---")
    if ($endIdx -lt 0) { return $null }
    $yaml = $rest.Substring(0, $endIdx).Trim()
    return $yaml
}

function Try-ConvertFromYaml {
    param([string]$YamlText)
    # Attempt to use powershell-yaml if available; fallback to $null
    try {
        $module = Get-Module -ListAvailable -Name powershell-yaml | Select-Object -First 1
        if ($module) {
            Import-Module powershell-yaml -ErrorAction Stop | Out-Null
            return ConvertFrom-Yaml -Yaml $YamlText
        }
    } catch { }
    return $null
}

function Validate-RequiredKeys {
    param(
        [string]$YamlText,
        [object]$YamlObj
    )
    $results = @()

    $requiredKeys = @('agent_id','phase','description','triggers','policies')
    foreach ($key in $requiredKeys) {
        $has = $false
        if ($YamlObj -ne $null) {
            $has = ($YamlObj.PSObject.Properties.Name -contains $key)
        } else {
            $has = ($YamlText -match "(?m)^\s*$key\s*:")
        }
        if (-not $has) { $results += "FAIL: missing key '$key'" }
    }
    return $results
}

function Validate-FileSpecificRules {
    param(
        [string]$Name,
        [string]$YamlText,
        [object]$YamlObj
    )
    $issues = @()
    switch -Regex ($Name) {
        'Persona\.md$' {
            if ($YamlObj) {
                if ($YamlObj.policies.language -ne 'ja') { $issues += "FAIL: policies.language must be 'ja'" }
                if ($YamlObj.policies.tone -ne 'ギャル') { $issues += "FAIL: policies.tone must be 'ギャル'" }
            } else {
                if ($YamlText -notmatch '(?m)^\s*language:\s*ja') { $issues += "FAIL: policies.language must be 'ja'" }
                if ($YamlText -notmatch '(?m)^\s*tone:\s*ギャル') { $issues += "FAIL: policies.tone must be 'ギャル'" }
            }
        }
        'GitHub\.md$' {
            if ($YamlObj) {
                if (-not $YamlObj.policies.require_readme_update_before_push) { $issues += "FAIL: require_readme_update_before_push must be true" }
                if (-not $YamlObj.metadata.account_url) { $issues += "FAIL: metadata.account_url missing" }
                if (-not $YamlObj.metadata.email) { $issues += "FAIL: metadata.email missing" }
            } else {
                if ($YamlText -notmatch '(?m)^\s*require_readme_update_before_push:\s*true') { $issues += "FAIL: require_readme_update_before_push must be true" }
                if ($YamlText -notmatch '(?m)^\s*account_url:\s*') { $issues += "FAIL: metadata.account_url missing" }
                if ($YamlText -notmatch '(?m)^\s*email:\s*') { $issues += "FAIL: metadata.email missing" }
            }
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*pre_push') { $issues += "WARN: triggers should include type 'pre_push'" }
        }
        'Development\.md$' {
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*default_target') { $issues += "WARN: missing trigger 'default_target'" }
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*doc_format') { $issues += "WARN: missing trigger 'doc_format'" }
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*process_model') { $issues += "WARN: missing trigger 'process_model'" }
            if ($YamlObj) {
                foreach ($k in 'review_each_phase','issue_driven','self_driven_until_requirements_test_done','iterate_until_no_major_findings') {
                    if (-not ($YamlObj.policies.PSObject.Properties.Name -contains $k)) { $issues += "WARN: policies.$k missing" }
                }
            }
        }
        'Requirements\.md$' {
            if ($YamlObj) {
                if ($YamlObj.policies.document_dir -ne 'requirement/') { $issues += "FAIL: policies.document_dir must be 'requirement/'" }
            } else {
                if ($YamlText -notmatch '(?m)^\s*document_dir:\s*requirement/') { $issues += "FAIL: policies.document_dir must be 'requirement/'" }
            }
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*gate') { $issues += "WARN: triggers should include type 'gate'" }
        }
        'Design\.md$' {
            if ($YamlObj) {
                if ($YamlObj.policies.document_dir -ne 'design/') { $issues += "FAIL: policies.document_dir must be 'design/'" }
            } else {
                if ($YamlText -notmatch '(?m)^\s*document_dir:\s*design/') { $issues += "FAIL: policies.document_dir must be 'design/'" }
            }
        }
        'Implementation\.md$' {
            if ($YamlObj) {
                if ($YamlObj.policies.review_perspective -ne 'veteran_engineer') { $issues += "FAIL: policies.review_perspective must be 'veteran_engineer'" }
            } else {
                if ($YamlText -notmatch '(?m)^\s*review_perspective:\s*veteran_engineer') { $issues += "FAIL: policies.review_perspective must be 'veteran_engineer'" }
            }
        }
        'Test\.md$' {
            if ($YamlObj) {
                if ($YamlObj.policies.document_dir -ne 'test/') { $issues += "FAIL: policies.document_dir must be 'test/'" }
            } else {
                if ($YamlText -notmatch '(?m)^\s*document_dir:\s*test/') { $issues += "FAIL: policies.document_dir must be 'test/'" }
            }
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*android_tv_remote') { $issues += "WARN: triggers should include type 'android_tv_remote'" }
            if ($YamlText -notmatch '(?s)triggers:.*type:\s*capture_rules') { $issues += "WARN: triggers should include type 'capture_rules'" }
        }
    }
    return $issues
}

function Check-DocumentDirExists {
    param(
        [string]$RepoRoot,
        [string]$YamlText,
        [object]$YamlObj,
        [string]$BaseDir
    )
    $dir = $null
    if ($YamlObj -and $YamlObj.policies) { $dir = $YamlObj.policies.document_dir }
    if (-not $dir -and $YamlText) {
        if ($YamlText -match '(?m)^\s*document_dir:\s*(.+?)\s*$') { $dir = $Matches[1] }
    }
    if ($dir) {
        $full = Join-Path $BaseDir $dir
        if (-not (Test-Path $full)) { return "WARN: document_dir '$dir' does not exist at '$full'" }
    }
    return $null
}

$baseDir = Join-Path $RepoRoot 'SubAgents'
$repoSettingsDir = Split-Path -Parent $baseDir

$files = Get-ChildItem -Path $baseDir -Filter '*.md' -File
if (-not $files) { Write-Error "No SubAgents markdown files found in $baseDir" }

$failCount = 0
$warnCount = 0

foreach ($f in $files) {
    Write-Host "\n== Validating: $($f.Name) ==" -ForegroundColor Cyan
    $yamlText = Get-YamlFrontMatter -Path $f.FullName
    if (-not $yamlText) {
        Write-Host "FAIL: No YAML front matter found (--- ... ---)" -ForegroundColor Red
        $failCount++
        continue
    }
    $yamlObj = Try-ConvertFromYaml -YamlText $yamlText

    $keyIssues = Validate-RequiredKeys -YamlText $yamlText -YamlObj $yamlObj
    foreach ($i in $keyIssues) {
        if ($i -like 'FAIL*') { $failCount++ ; Write-Host $i -ForegroundColor Red } else { $warnCount++ ; Write-Host $i -ForegroundColor Yellow }
    }

    $fileIssues = Validate-FileSpecificRules -Name $f.Name -YamlText $yamlText -YamlObj $yamlObj
    foreach ($i in $fileIssues) {
        if ($i -like 'FAIL*') { $failCount++ ; Write-Host $i -ForegroundColor Red } else { $warnCount++ ; Write-Host $i -ForegroundColor Yellow }
    }

    $dirIssue = Check-DocumentDirExists -RepoRoot $RepoRoot -YamlText $yamlText -YamlObj $yamlObj -BaseDir $repoSettingsDir
    if ($dirIssue) { $warnCount++ ; Write-Host $dirIssue -ForegroundColor Yellow }

    Write-Host "Validation complete for $($f.Name)" -ForegroundColor Green
}

Write-Host "\nSummary: FAIL=$failCount, WARN=$warnCount" -ForegroundColor Magenta
if ($failCount -gt 0) { exit 1 } else { exit 0 }
