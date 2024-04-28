$userChoiceKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\UserChoice'
$userChoice = Get-ItemProperty -Path $userChoiceKey -Name Progid -ErrorAction SilentlyContinue
if ($userChoice) {
    $progId = $userChoice.Progid
    $appPathKey = "HKLM:\SOFTWARE\Classes\$progId\shell\open\command"
    $appPath = (Get-ItemProperty -Path $appPathKey).'(default)'
    if ($appPath.StartsWith('"')) {
        $appPath = $appPath.Split('"')[1]
    } else {
        $appPath = $appPath.Split(' ')[0]
    }
    $filePath = Join-Path -Path $PSScriptRoot -ChildPath "DefaultBrowserPath.txt"
    $appPath | Out-File -FilePath $filePath
    "Path written to file: $filePath"
} else {
    "Default browser not found or access denied."
}
