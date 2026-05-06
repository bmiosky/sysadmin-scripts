# ============================================================
# Get-SystemInfo.ps1
# Description: Collects and displays key system information
#              including hostname, OS, CPU, RAM, disk, and uptime.
# Author:      Ben Miosky
# Usage:       Right-click > Run with PowerShell
#              OR from terminal: .\Get-SystemInfo.ps1
# ============================================================

# --- Header ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "        SYSTEM INFORMATION REPORT       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# --- Computer & OS ---
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem

Write-Host "[ COMPUTER ]" -ForegroundColor Yellow
Write-Host "  Hostname       : $($cs.Name)"
Write-Host "  Manufacturer   : $($cs.Manufacturer)"
Write-Host "  Model          : $($cs.Model)"
Write-Host "  Domain/Workgrp : $($cs.Domain)"
Write-Host ""

Write-Host "[ OPERATING SYSTEM ]" -ForegroundColor Yellow
Write-Host "  OS Name        : $($os.Caption)"
Write-Host "  Version        : $($os.Version)"
Write-Host "  Build          : $($os.BuildNumber)"
Write-Host "  Architecture   : $($os.OSArchitecture)"
Write-Host "  Install Date   : $($os.InstallDate.ToString('yyyy-MM-dd'))"
Write-Host ""

# --- Uptime ---
$uptime = (Get-Date) - $os.LastBootUpTime
Write-Host "[ UPTIME ]" -ForegroundColor Yellow
Write-Host "  Last Boot      : $($os.LastBootUpTime.ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "  Uptime         : $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
Write-Host ""

# --- CPU ---
$cpu = Get-CimInstance Win32_Processor

Write-Host "[ CPU ]" -ForegroundColor Yellow
Write-Host "  Name           : $($cpu.Name.Trim())"
Write-Host "  Cores          : $($cpu.NumberOfCores)"
Write-Host "  Logical CPUs   : $($cpu.NumberOfLogicalProcessors)"
Write-Host "  Max Speed      : $($cpu.MaxClockSpeed) MHz"
Write-Host ""

# --- RAM ---
$totalRAM = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
$freeRAM  = [math]::Round($os.FreePhysicalMemory / 1MB / 1024, 2)
$usedRAM  = [math]::Round($totalRAM - $freeRAM, 2)
$ramPct   = [math]::Round(($usedRAM / $totalRAM) * 100, 1)

Write-Host "[ MEMORY (RAM) ]" -ForegroundColor Yellow
Write-Host "  Total          : $totalRAM GB"
Write-Host "  Used           : $usedRAM GB ($ramPct% in use)"
Write-Host "  Free           : $freeRAM GB"
Write-Host ""

# --- Disk Drives ---
Write-Host "[ DISK DRIVES ]" -ForegroundColor Yellow
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

foreach ($disk in $disks) {
    $total   = [math]::Round($disk.Size / 1GB, 1)
    $free    = [math]::Round($disk.FreeSpace / 1GB, 1)
    $used    = [math]::Round($total - $free, 1)
    $pctFree = [math]::Round(($free / $total) * 100, 1)

    # Warn if disk is low on space
    $color = if ($pctFree -lt 15) { "Red" } elseif ($pctFree -lt 25) { "DarkYellow" } else { "White" }

    Write-Host "  Drive $($disk.DeviceID)" -ForegroundColor $color
    Write-Host "    Total      : $total GB" -ForegroundColor $color
    Write-Host "    Used       : $used GB" -ForegroundColor $color
    Write-Host "    Free       : $free GB ($pctFree% free)" -ForegroundColor $color
}
Write-Host ""

# --- Network Adapters ---
Write-Host "[ NETWORK ADAPTERS ]" -ForegroundColor Yellow
$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

foreach ($adapter in $adapters) {
    Write-Host "  Adapter        : $($adapter.Description)"
    Write-Host "    IP Address   : $($adapter.IPAddress -join ', ')"
    Write-Host "    Subnet Mask  : $($adapter.IPSubnet -join ', ')"
    Write-Host "    Gateway      : $($adapter.DefaultIPGateway -join ', ')"
    Write-Host "    MAC Address  : $($adapter.MACAddress)"
    Write-Host "    DNS Servers  : $($adapter.DNSServerSearchOrder -join ', ')"
    Write-Host ""
}

# --- Current User ---
Write-Host "[ CURRENT USER ]" -ForegroundColor Yellow
Write-Host "  Logged In As   : $($env:USERDOMAIN)\$($env:USERNAME)"
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "             END OF REPORT              " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
