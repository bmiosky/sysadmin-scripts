# 🖥️ SysAdmin Scripts

A collection of PowerShell scripts for common Windows system administration tasks — auditing, monitoring, maintenance, and troubleshooting.

Built and maintained by [Ben Miosky](https://github.com/bmiosky).

---

## 📋 Scripts

### `Get-SystemInfo.ps1`
Generates a detailed system information report for a Windows machine.

**Collects:**
- Computer name, manufacturer, and model
- Operating system version and build
- System uptime and last boot time
- CPU name, cores, and speed
- RAM usage (total, used, free)
- Disk drive usage with low-space warnings
- Active network adapter details (IP, MAC, DNS, gateway)
- Currently logged-in user

**Usage:**
```powershell
.\Get-SystemInfo.ps1
```

> **Note:** If you receive an execution policy error, run the following first:
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
> Unblock-File -Path ".\Get-SystemInfo.ps1"
> ```

---

## ⚙️ Requirements

- Windows 10 or later
- PowerShell 5.1 or later
- Run as standard user (no admin rights required unless noted)

---

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/bmiosky/sysadmin-scripts
   ```
2. Navigate to the folder:
   ```bash
   cd sysadmin-scripts
   ```
3. Run any script from PowerShell:
   ```powershell
   .\ScriptName.ps1
   ```

---

## 📌 Roadmap

Scripts planned for future addition:

- [ ] Disk Space Alert — flags drives below a free space threshold
- [ ] Failed Login Checker — queries Event Log for ID 4625
- [ ] Local User Account Lister — audits local accounts and status
- [ ] Pending Updates Checker — reports outstanding Windows updates
- [ ] Network Info Snapshot — captures and saves network diagnostics

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
